import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../services/supabase_service.dart';
import 'login_controller.dart';

class EksepsiController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final eksepsiFormKey = GlobalKey<FormState>();
  final eksepsiEntries = <Map<String, TextEditingController>>[].obs;

  final currentUser = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;
  final isLoadingUser = false.obs;
  final isLoadingHistory = false.obs;
  final eksepsiHistory = <Map<String, dynamic>>[].obs;

  final String jenisEksepsi = 'Jam Masuk & Jam Pulang';
  final LoginController loginController = Get.find<LoginController>();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    addEksepsiEntry();
    _initializeUserAndHistory();
  }

  Future<void> _initializeUserAndHistory() async {
    await loadCurrentUser();
    await loadEksepsiHistory();
  }

  Future<void> loadCurrentUser() async {
    isLoadingUser.value = true;
    try {
      final user = loginController.currentUser.value;

      if (user != null) {
        final result = await SupabaseService.instance.client
            .from('users')
            .select()
            .eq('id', user['id'])
            .single();

        currentUser.value = result;
      } else {
        currentUser.value = null;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data pengguna: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingUser.value = false;
    }
  }

  String? validateTanggalEksepsi(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal eksepsi harus diisi';
    }
    try {
      // Validasi hanya format tanggal, tanpa membatasi ke masa depan/masa lalu
      DateFormat('dd/MM/yyyy').parseStrict(value);
      return null;
    } catch (e) {
      return 'Format tanggal tidak valid (dd/MM/yyyy)';
    }
  }

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

      final validEntries = <Map<String, dynamic>>[];
      for (int i = 0; i < eksepsiEntries.length; i++) {
        final entry = eksepsiEntries[i];
        final alasanController = entry['alasan']!;
        final tanggalController = entry['tanggal']!;

        if (alasanController.text.trim().isEmpty ||
            tanggalController.text.trim().isEmpty) {
          continue;
        }

        DateTime? parsedDate;
        try {
          parsedDate =
              DateFormat('dd/MM/yyyy').parseStrict(tanggalController.text);
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

        final tanggalData = validEntries
            .map((entry) => {
                  'eksepsi_id': eksepsiId,
                  'tanggal_eksepsi':
                      DateFormat('yyyy-MM-dd').format(entry['tanggal']),
                  'urutan': entry['urutan'],
                  'alasan_eksepsi': entry['alasan'],
                })
            .toList();

        await SupabaseService.instance.client
            .from('eksepsi_tanggal')
            .insert(tanggalData);
      } catch (e) {
        for (final entry in validEntries) {
          await SupabaseService.instance.client.from('eksepsi').insert({
            'user_id': user['id'],
            'jenis_eksepsi': jenisEksepsi,
            'alasan_eksepsi': entry['alasan'],
            'list_tanggal_eksepsi':
                DateFormat('yyyy-MM-dd').format(entry['tanggal']),
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
      await loadEksepsiHistory();
      tabController.animateTo(1);
    } catch (e) {
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

  Future<void> loadEksepsiHistory() async {
    isLoadingHistory.value = true;
    try {
      final user = currentUser.value;

      if (user != null) {
        try {
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

          final transformedData = result.map((item) {
            final tanggalList = (item['eksepsi_tanggal'] as List? ?? [])
                .map((t) => t['tanggal_eksepsi'] as String)
                .toList()
              ..sort();

            final firstAlasan = (item['eksepsi_tanggal'] as List? ?? [])
                    .isNotEmpty
                ? (item['eksepsi_tanggal'] as List)[0]['alasan_eksepsi'] ?? ''
                : '';

            return {
              ...item,
              'list_tanggal_eksepsi': tanggalList.join(', '),
              'jumlah_hari': tanggalList.length,
              'alasan_eksepsi': firstAlasan,
            };
          }).toList();

          eksepsiHistory.value =
              List<Map<String, dynamic>>.from(transformedData);
        } catch (e) {
          final result = await SupabaseService.instance.client
              .from('eksepsi')
              .select()
              .eq('user_id', user['id'])
              .order('tanggal_pengajuan', ascending: false);

          eksepsiHistory.value = List<Map<String, dynamic>>.from(result);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat history eksepsi: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<void> deleteEksepsi(Map<String, dynamic> eksepsiData) async {
    try {
      final eksepsiId = eksepsiData['id'];

      await SupabaseService.instance.client
          .from('eksepsi')
          .delete()
          .eq('id', eksepsiId);

      await loadEksepsiHistory();
      // Pastikan tidak ada overlay yang masih terbuka sebelum menampilkan snackbar
      try {
        if (Get.isDialogOpen == true) {
          Get.back();
        }
        if (Get.isSnackbarOpen == true) {
          Get.closeAllSnackbars();
        }
      } catch (_) {
        // abaikan jika properti tidak tersedia pada versi GetX
      }

      Get.snackbar(
        'Berhasil',
        'Eksepsi berhasil dihapus',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      // Tutup overlay yang mungkin mengganggu sebelum menampilkan snackbar error
      try {
        if (Get.isDialogOpen == true) {
          Get.back();
        }
        if (Get.isSnackbarOpen == true) {
          Get.closeAllSnackbars();
        }
      } catch (_) {}
      Get.snackbar(
        'Error',
        'Gagal menghapus eksepsi: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> showDeleteConfirmation(Map<String, dynamic> eksepsiData) async {
    final dateString = eksepsiData['list_tanggal_eksepsi'] ?? '';
    final dates = dateString.isNotEmpty
        ? dateString.split(',').map((e) => e.trim()).toList()
        : <String>[];
    // Tutup snackbar aktif sebelum membuka dialog untuk menghindari konflik overlay
    try {
      if (Get.isSnackbarOpen == true) {
        Get.closeAllSnackbars();
      }
    } catch (_) {
      // abaikan jika properti tidak tersedia pada versi GetX
    }
    // Beri jeda singkat agar overlay benar-benar tertutup
    await Future.delayed(const Duration(milliseconds: 50));

    final confirmed = await Get.dialog<bool>(
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
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (confirmed == true) {
      // Beri jeda singkat untuk memastikan dialog benar-benar tertutup
      await Future.delayed(const Duration(milliseconds: 50));
      await deleteEksepsi(eksepsiData);
    }
  }

  Future<void> refreshData() async {
    await loadCurrentUser();
    await loadEksepsiHistory();
  }

  void addEksepsiEntry() {
    eksepsiEntries.add({
      'alasan': TextEditingController(),
      'tanggal': TextEditingController(),
    });
  }

  void removeEksepsiEntry(int index) {
    if (eksepsiEntries.length > 1) {
      final alasan = eksepsiEntries[index]['alasan'];
      final tanggal = eksepsiEntries[index]['tanggal'];
      // Lepas dulu dari UI, baru dispose setelah frame berikutnya
      eksepsiEntries.removeAt(index);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        alasan?.dispose();
        tanggal?.dispose();
      });
    }
  }

  void setSelectedDate(DateTime date, int index) {
    if (index < eksepsiEntries.length) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(date);
      eksepsiEntries[index]['tanggal']?.text = formattedDate;
    }
  }

  void clearForm() {
    // Buang entri tambahan dengan aman (detach dari UI dulu)
    if (eksepsiEntries.length > 1) {
      final toDispose = eksepsiEntries
          .sublist(1)
          .map((e) => [e['alasan'], e['tanggal']])
          .toList();
      eksepsiEntries.removeRange(1, eksepsiEntries.length);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (final pair in toDispose) {
          pair[0]?.dispose();
          pair[1]?.dispose();
        }
      });
    }
    if (eksepsiEntries.isNotEmpty) {
      eksepsiEntries[0]['alasan']?.clear();
      eksepsiEntries[0]['tanggal']?.clear();
    }
    eksepsiFormKey.currentState?.reset();
  }

  @override
  void onClose() {
    for (final entry in eksepsiEntries) {
      entry['alasan']?.dispose();
      entry['tanggal']?.dispose();
    }
    tabController.dispose();
    super.onClose();
  }

  String? validateAlasan(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Alasan eksepsi harus diisi';
    }
    return null;
  }

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
