// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/supabase_service.dart';
import 'login_controller.dart';

class CutiController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Form key
  final cutiFormKey = GlobalKey<FormState>();

  // Controllers
  final alasanController = TextEditingController();
  late TabController tabController;

  // Observable state variables
  final isLoading = false.obs;
  final isLoadingUser = false.obs;
  final isLoadingHistory = false.obs;
  final currentUser = Rxn<Map<String, dynamic>>();
  final sisaCuti = 0.obs;

  // History data
  final cutiHistory = <Map<String, dynamic>>[].obs;

  // Calendar variables
  final selectedDates = <DateTime>[].obs;
  final focusedDay = DateTime.now().obs;
  final calendarFormat = CalendarFormat.month.obs;

  // Login controller reference
  final LoginController loginController = Get.find<LoginController>();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    _initializeData();
  }

  Future<void> _initializeData() async {
    await loadCurrentUser();
    await loadCutiHistory();
  }

  @override
  void onClose() {
    alasanController.dispose();
    tabController.dispose();
    super.onClose();
  }

  // Load current user data with sisa_cuti
  Future<void> loadCurrentUser() async {
    isLoadingUser.value = true;
    try {
      final user = loginController.currentUser.value;
      if (user != null) {
        // Get fresh user data with sisa_cuti
        final result = await SupabaseService.instance.client
            .from('users')
            .select()
            .eq('id', user['id'])
            .single();

        currentUser.value = result;
        sisaCuti.value =
            result['sisa_cuti'] ?? 12; // Default 12 hari cuti per tahun
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

  // Toggle date selection
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (selectedDates.contains(selectedDay)) {
      selectedDates.remove(selectedDay);
    } else {
      selectedDates.add(selectedDay);
    }

    this.focusedDay.value = focusedDay;
    selectedDates.sort();
  }

  // Clear selected dates
  void clearSelectedDates() {
    selectedDates.clear();
  }

  // Submit cuti application
  Future<void> submitCutiApplication() async {
    if (!cutiFormKey.currentState!.validate()) return;

    if (selectedDates.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Silakan pilih tanggal cuti terlebih dahulu',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final lamaCuti = selectedDates.length;
    if (lamaCuti > sisaCuti.value) {
      Get.snackbar(
        'Peringatan',
        'Jumlah hari cuti ($lamaCuti) melebihi sisa cuti Anda (${sisaCuti.value})',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;

    try {
      final user = currentUser.value!;

      // Format selected dates as comma-separated string
      final tanggalCutiList = selectedDates
          .map((date) => date.toString().split(' ')[0])
          .join(',');

      // Prepare cuti data
      final cutiData = {
        'users_id': user['id'], // Use foreign key instead of nama
        'nama': user['name'],
        'alasan_cuti': alasanController.text.trim(),
        'lama_cuti': lamaCuti,
        'list_tanggal_cuti': tanggalCutiList,
        'sisa_cuti': sisaCuti.value - lamaCuti,
        'tanggal_pengajuan': DateTime.now().toIso8601String(),
      };

      // Insert cuti data
      await SupabaseService.instance.client.from('cuti').insert(cutiData);

      // Update user's sisa_cuti
      await SupabaseService.instance.client
          .from('users')
          .update({'sisa_cuti': sisaCuti.value - lamaCuti})
          .eq('id', user['id']);

      Get.snackbar(
        'Berhasil',
        'Pengajuan cuti berhasil disubmit!\nSisa cuti Anda: ${sisaCuti.value - lamaCuti} hari',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );

      // Clear form
      clearForm();

      // Refresh user data and history
      await loadCurrentUser();
      await loadCutiHistory();

      // Switch to history tab to show the new submission
      tabController.animateTo(1);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengajukan cuti: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load cuti history for current user
  Future<void> loadCutiHistory() async {
    isLoadingHistory.value = true;
    try {
      final user = currentUser.value;

      if (user != null) {
        final result = await SupabaseService.instance.client
            .from('cuti')
            .select()
            .eq('users_id', user['id']) // Use foreign key instead of nama
            .order('tanggal_pengajuan', ascending: false);

        cutiHistory.value = List<Map<String, dynamic>>.from(result);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat history cuti: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingHistory.value = false;
    }
  }

  // Toggle kunci cuti (lock/unlock)
  Future<void> toggleKunciCuti(Map<String, dynamic> cutiData) async {
    try {
      final cutiId = cutiData['id'];
      final currentLockStatus = cutiData['kunci_cuti'] ?? false;
      final newLockStatus = !currentLockStatus;

      // Update lock status
      await SupabaseService.instance.client
          .from('cuti')
          .update({'kunci_cuti': newLockStatus})
          .eq('id', cutiId);

      // Refresh data
      await loadCutiHistory();

      Get.snackbar(
        'Berhasil',
        newLockStatus
            ? 'Cuti berhasil dikunci. Data tidak dapat dihapus.'
            : 'Kunci cuti berhasil dibuka. Data dapat dihapus kembali.',
        backgroundColor: newLockStatus ? Colors.orange : Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengubah status kunci cuti: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Delete cuti and restore leave balance
  Future<void> deleteCuti(Map<String, dynamic> cutiData) async {
    try {
      final cutiId = cutiData['id'];
      final userId = cutiData['users_id'];

      // Parse the leave dates to calculate days to restore
      final dateString = cutiData['list_tanggal_cuti'] ?? '';
      final dates = dateString.isNotEmpty
          ? dateString.split(',').map((e) => e.trim()).toList()
          : <String>[];
      final daysToRestore = dates.length;

      if (daysToRestore == 0) {
        Get.snackbar(
          'Error',
          'Tidak dapat menghitung hari cuti yang akan dikembalikan',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // Start transaction-like operations
      // 1. Delete the cuti record
      await SupabaseService.instance.client
          .from('cuti')
          .delete()
          .eq('id', cutiId);

      // 2. Get current user's leave balance
      final userResult = await SupabaseService.instance.client
          .from('users')
          .select('sisa_cuti')
          .eq('id', userId)
          .single();

      final currentBalance = userResult['sisa_cuti'] ?? 0;
      final newBalance = currentBalance + daysToRestore;

      // 3. Update user's leave balance
      await SupabaseService.instance.client
          .from('users')
          .update({'sisa_cuti': newBalance})
          .eq('id', userId);

      // 4. Refresh data
      await refreshData();

      Get.snackbar(
        'Berhasil',
        'Cuti berhasil dihapus dan $daysToRestore hari cuti dikembalikan',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus cuti: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Show delete confirmation dialog
  Future<void> showDeleteConfirmation(Map<String, dynamic> cutiData) async {
    // Check if cuti is locked
    final isLocked = cutiData['kunci_cuti'] ?? false;

    if (isLocked) {
      Get.snackbar(
        'Tidak Dapat Dihapus',
        'Cuti ini sudah dikunci dan tidak dapat dihapus',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final dateString = cutiData['list_tanggal_cuti'] ?? '';
    final dates = dateString.isNotEmpty
        ? dateString.split(',').map((e) => e.trim()).toList()
        : <String>[];
    final daysCount = dates.length;

    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Apakah Anda yakin ingin menghapus cuti ini?'),
            const SizedBox(height: 8),
            Text(
              '• Tanggal: ${dates.isNotEmpty ? "${dates.first} - ${dates.last}" : "-"}',
            ),
            Text('• Durasi: $daysCount hari'),
            Text('• Alasan: ${cutiData['alasan_cuti'] ?? "-"}'),
            const SizedBox(height: 8),
            Text(
              '$daysCount hari cuti akan dikembalikan ke saldo Anda.',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              deleteCuti(cutiData);
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

  // Show lock/unlock confirmation dialog
  Future<void> showLockConfirmation(Map<String, dynamic> cutiData) async {
    final isCurrentlyLocked = cutiData['kunci_cuti'] ?? false;
    final dateString = cutiData['list_tanggal_cuti'] ?? '';
    final dates = dateString.isNotEmpty
        ? dateString.split(',').map((e) => e.trim()).toList()
        : <String>[];

    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(
              isCurrentlyLocked ? Icons.lock_open : Icons.lock,
              color: isCurrentlyLocked ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            Text(isCurrentlyLocked ? 'Buka Kunci Cuti' : 'Kunci Cuti'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isCurrentlyLocked
                  ? 'Apakah Anda yakin ingin membuka kunci cuti ini?'
                  : 'Apakah Anda yakin ingin mengunci cuti ini?',
            ),
            const SizedBox(height: 8),
            Text(
              '• Tanggal: ${dates.isNotEmpty ? "${dates.first} - ${dates.last}" : "-"}',
            ),
            Text('• Alasan: ${cutiData['alasan_cuti'] ?? "-"}'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isCurrentlyLocked ? Colors.green : Colors.orange)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isCurrentlyLocked
                    ? 'Setelah dibuka, cuti ini dapat dihapus kembali.'
                    : 'Setelah dikunci, cuti ini tidak dapat dihapus.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCurrentlyLocked ? Colors.green : Colors.orange,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              toggleKunciCuti(cutiData);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isCurrentlyLocked ? Colors.green : Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text(isCurrentlyLocked ? 'Buka Kunci' : 'Kunci'),
          ),
        ],
      ),
    );
  }

  // Refresh all data
  Future<void> refreshData() async {
    await loadCurrentUser();
    await loadCutiHistory();
  }

  // Clear form
  void clearForm() {
    alasanController.clear();
    selectedDates.clear();
    focusedDay.value = DateTime.now();
  }

  // Form validators
  String? validateAlasan(String? value) {
    if (value == null || value.isEmpty) {
      return 'Alasan cuti tidak boleh kosong';
    }
    return null;
  }

  // Calendar helpers
  bool isSelectedDay(DateTime day) {
    return selectedDates.any((selected) => isSameDay(selected, day));
  }

  // Change calendar format
  void changeCalendarFormat() {
    calendarFormat.value = calendarFormat.value == CalendarFormat.month
        ? CalendarFormat.twoWeeks
        : CalendarFormat.month;
  }
}
