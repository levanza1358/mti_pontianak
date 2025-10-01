import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../services/supabase_service.dart';
import 'login_controller.dart';

class EksepsiController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Tab controller
  late TabController tabController;

  // Form key
  final eksepsiFormKey = GlobalKey<FormState>();

  // Form controllers - now supporting multiple entries
  final eksepsiEntries = <Map<String, TextEditingController>>[].obs;

  // Observable variables
  final currentUser = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;
  final isLoadingUser = false.obs;
  final isLoadingHistory = false.obs;
  final eksepsiHistory = <Map<String, dynamic>>[].obs;

  // Fixed jenis eksepsi - no longer variable
  final String jenisEksepsi = 'Jam Masuk & Jam Pulang';

  // Login controller reference
  final LoginController loginController = Get.find<LoginController>();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    // Initialize with one eksepsi entry
    addEksepsiEntry();
    // Load current user first, then load history
    _initializeUserAndHistory();
  }

  // Initialize user and history in proper order
  Future<void> _initializeUserAndHistory() async {
    await loadCurrentUser();
    await loadEksepsiHistory();
  }

  // Load current user data
  Future<void> loadCurrentUser() async {
    print('🔍 [DEBUG] Starting loadCurrentUser...');
    isLoadingUser.value = true;
    try {
      final user = loginController.currentUser.value;
      print('🔍 [DEBUG] loginController.currentUser.value: $user');
      
      if (user != null) {
        print('🔍 [DEBUG] User found, fetching fresh data from database...');
        // Get fresh user data
        final result = await SupabaseService.instance.client
            .from('users')
            .select()
            .eq('id', user['id'])
            .single();

        print('🔍 [DEBUG] Fresh user data from database: $result');
        currentUser.value = result;
        print('🔍 [DEBUG] currentUser.value set to: ${currentUser.value}');
      } else {
        print('❌ [DEBUG] No user found in loginController.currentUser.value');
        currentUser.value = null;
      }
    } catch (e) {
      print('❌ [DEBUG] Error in loadCurrentUser: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data pengguna: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingUser.value = false;
      print('✅ [DEBUG] loadCurrentUser completed. Final currentUser: ${currentUser.value}');
    }
  }

  // Legacy method - now handled by setSelectedDate(DateTime date, int index)
  // This method is kept for backward compatibility but should not be used

  // Validate tanggal eksepsi
  String? validateTanggalEksepsi(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal eksepsi harus diisi';
    }
    
    try {
      final date = DateFormat('dd/MM/yyyy').parseStrict(value);
      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);
      
      if (date.isBefore(todayOnly)) {
        return 'Tanggal eksepsi tidak boleh sebelum hari ini';
      }
      
      return null;
    } catch (e) {
      return 'Format tanggal tidak valid (dd/MM/yyyy)';
    }
  }

  // Get single date from input - legacy method, not used in current implementation
  DateTime? getSingleDateFromInput() {
    // This method is no longer used since we moved to multiple entries
    // Keeping for backward compatibility
    return null;
  }

  // Submit eksepsi application (fallback to old schema if new schema fails)
  Future<void> submitEksepsiApplication() async {
    if (!eksepsiFormKey.currentState!.validate()) {
      Get.snackbar(
        'Error',
        'Mohon lengkapi form dengan benar',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final user = currentUser.value;
      if (user == null) {
        throw Exception('User data tidak ditemukan');
      }

      // Collect and validate all dates first
      final validEntries = <Map<String, dynamic>>[];
      for (int i = 0; i < eksepsiEntries.length; i++) {
        final entry = eksepsiEntries[i];
        final alasanController = entry['alasan']!;
        final tanggalController = entry['tanggal']!;

        // Skip empty entries
        if (alasanController.text.trim().isEmpty || tanggalController.text.trim().isEmpty) {
          continue;
        }

        // Parse date
        DateTime? parsedDate;
        try {
          parsedDate = DateFormat('dd/MM/yyyy').parseStrict(tanggalController.text);
        } catch (e) {
          Get.snackbar(
            'Error',
            'Format tanggal tidak valid pada eksepsi ${i + 1}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        validEntries.add({
          'alasan': alasanController.text.trim(),
          'tanggal': parsedDate,
          'urutan': i + 1,
        });
      }

      if (validEntries.isEmpty) {
        Get.snackbar(
          'Error',
          'Minimal harus ada satu tanggal eksepsi',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      try {
        // Try new normalized schema first
        // 1. Insert main eksepsi record
        final eksepsiData = {
          'user_id': user['id'],
          'jenis_eksepsi': jenisEksepsi,
        };

        final eksepsiResponse = await SupabaseService.instance.client
            .from('eksepsi')
            .insert(eksepsiData)
            .select()
            .single();

        final eksepsiId = eksepsiResponse['id'];

        // 2. Insert all dates to eksepsi_tanggal table
        final tanggalData = validEntries.map((entry) => {
          'eksepsi_id': eksepsiId,
          'tanggal_eksepsi': DateFormat('yyyy-MM-dd').format(entry['tanggal']),
          'urutan': entry['urutan'],
          'alasan_eksepsi': entry['alasan'], // Add individual alasan for each date
        }).toList();

        await SupabaseService.instance.client
            .from('eksepsi_tanggal')
            .insert(tanggalData);

      } catch (e) {
        // Fallback to old schema if new schema doesn't exist
        print('New schema failed, trying old schema: $e');
        
        // Use old schema - insert each date as separate record
        for (final entry in validEntries) {
          await SupabaseService.instance.client.from('eksepsi').insert({
            'user_id': user['id'],
            'jenis_eksepsi': jenisEksepsi,
            'alasan_eksepsi': entry['alasan'],
            'list_tanggal_eksepsi': DateFormat('yyyy-MM-dd').format(entry['tanggal']),
            'jumlah_hari': 1,
            'tanggal_pengajuan': DateTime.now().toIso8601String(),
            'status_persetujuan': 'Menunggu',
          });
        }
      }

      Get.snackbar(
        'Berhasil',
        'Pengajuan eksepsi berhasil dikirim dengan ${validEntries.length} tanggal',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      clearForm();
      
      // Force refresh history before switching tabs
      await loadEksepsiHistory();
      
      // Switch to history tab after history is loaded
      tabController.animateTo(1);

    } catch (e) {
      print('Error submitting eksepsi: $e');
      Get.snackbar(
        'Error',
        'Gagal mengirim pengajuan: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load eksepsi history for current user (fallback to old schema if new schema fails)
  Future<void> loadEksepsiHistory() async {
    print('🔍 [DEBUG] Starting loadEksepsiHistory...');
    isLoadingHistory.value = true;
    try {
      final user = currentUser.value;
      print('🔍 [DEBUG] Current user: ${user?['id']}');

      if (user != null) {
        try {
          print('🔍 [DEBUG] Trying new normalized schema...');
          // Try new normalized schema first
          final result = await SupabaseService.instance.client
              .from('eksepsi')
              .select('''
                *,
                eksepsi_tanggal (
                  tanggal_eksepsi,
                  urutan,
                  alasan_eksepsi
                )
              ''')
              .eq('user_id', user['id'])
              .order('tanggal_pengajuan', ascending: false);

          print('🔍 [DEBUG] New schema query result: $result');
          print('🔍 [DEBUG] Result length: ${result.length}');

          // Transform data for UI compatibility
          final transformedData = result.map((item) {
            print('🔍 [DEBUG] Processing item: $item');
            final tanggalList = (item['eksepsi_tanggal'] as List? ?? [])
                .map((t) => t['tanggal_eksepsi'] as String)
                .toList()
                ..sort();

            // Get alasan for the first date (for backward compatibility in history display)
            final firstAlasan = (item['eksepsi_tanggal'] as List? ?? [])
                .isNotEmpty ? (item['eksepsi_tanggal'] as List)[0]['alasan_eksepsi'] ?? '' : '';

            print('🔍 [DEBUG] Tanggal list: $tanggalList');

            return {
              ...item,
              'list_tanggal_eksepsi': tanggalList.join(', '),
              'jumlah_hari': tanggalList.length,
              'alasan_eksepsi': firstAlasan, // For backward compatibility
            };
          }).toList();

          print('🔍 [DEBUG] Transformed data: $transformedData');
          eksepsiHistory.value = List<Map<String, dynamic>>.from(transformedData);
          print('🔍 [DEBUG] eksepsiHistory.value set to: ${eksepsiHistory.value}');
        } catch (e) {
          // Fallback to old schema if new schema doesn't exist
          print('❌ [DEBUG] New schema failed, trying old schema: $e');
          final result = await SupabaseService.instance.client
              .from('eksepsi')
              .select()
              .eq('user_id', user['id'])
              .order('tanggal_pengajuan', ascending: false);

          print('🔍 [DEBUG] Old schema query result: $result');
          print('🔍 [DEBUG] Old schema result length: ${result.length}');
          eksepsiHistory.value = List<Map<String, dynamic>>.from(result);
          print('🔍 [DEBUG] eksepsiHistory.value (old schema): ${eksepsiHistory.value}');
        }
      } else {
        print('❌ [DEBUG] No current user found!');
      }
    } catch (e) {
      print('❌ [DEBUG] Error loading eksepsi history: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat history eksepsi: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingHistory.value = false;
      print('✅ [DEBUG] loadEksepsiHistory completed. Final eksepsiHistory length: ${eksepsiHistory.value.length}');
    }
  }

  // Delete eksepsi
  Future<void> deleteEksepsi(Map<String, dynamic> eksepsiData) async {
    try {
      final eksepsiId = eksepsiData['id'];

      // Delete the eksepsi record
      await SupabaseService.instance.client
          .from('eksepsi')
          .delete()
          .eq('id', eksepsiId);

      // Refresh data
      await loadEksepsiHistory();

      Get.snackbar(
        'Berhasil',
        'Eksepsi berhasil dihapus',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus eksepsi: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Show delete confirmation dialog
  Future<void> showDeleteConfirmation(Map<String, dynamic> eksepsiData) async {
    final dateString = eksepsiData['list_tanggal_eksepsi'] ?? '';
    final dates = dateString.isNotEmpty
        ? dateString.split(',').map((e) => e.trim()).toList()
        : <String>[];

    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Apakah Anda yakin ingin menghapus eksepsi ini?'),
            const SizedBox(height: 8),
            Text(
              '• Tanggal: ${dates.isNotEmpty ? "${dates.first} - ${dates.last}" : "-"}',
            ),
            Text('• Jenis: ${eksepsiData['jenis_eksepsi'] ?? "-"}'),
            Text('• Alasan: ${eksepsiData['alasan_eksepsi'] ?? "-"}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              deleteEksepsi(eksepsiData);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // Refresh all data
  Future<void> refreshData() async {
    await loadCurrentUser();
    await loadEksepsiHistory();
  }

  // Add new eksepsi entry
  void addEksepsiEntry() {
    eksepsiEntries.add({
      'alasan': TextEditingController(),
      'tanggal': TextEditingController(),
    });
  }

  // Remove eksepsi entry
  void removeEksepsiEntry(int index) {
    if (eksepsiEntries.length > 1) {
      // Dispose controllers to prevent memory leaks
      eksepsiEntries[index]['alasan']?.dispose();
      eksepsiEntries[index]['tanggal']?.dispose();
      eksepsiEntries.removeAt(index);
    }
  }

  // Set selected date for specific entry
  void setSelectedDate(DateTime date, int index) {
    if (index < eksepsiEntries.length) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(date);
      eksepsiEntries[index]['tanggal']?.text = formattedDate;
    }
  }

  // Clear form
  void clearForm() {
    // Clear all entries except the first one
    while (eksepsiEntries.length > 1) {
      removeEksepsiEntry(eksepsiEntries.length - 1);
    }
    // Clear the remaining entry
    if (eksepsiEntries.isNotEmpty) {
      eksepsiEntries[0]['alasan']?.clear();
      eksepsiEntries[0]['tanggal']?.clear();
    }
    eksepsiFormKey.currentState?.reset();
  }

  // Form validators
  String? validateAlasan(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Alasan eksepsi harus diisi';
    }
    return null;
  }

  // Get status color
  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'disetujui':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      case 'menunggu':
      default:
        return Colors.orange;
    }
  }

  // Get status icon
  IconData getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'disetujui':
        return Icons.check_circle;
      case 'ditolak':
        return Icons.cancel;
      case 'menunggu':
      default:
        return Icons.access_time;
    }
  }
}