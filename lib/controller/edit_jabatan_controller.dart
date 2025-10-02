import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';

class EditJabatanController extends GetxController {
  // Form key
  final editJabatanFormKey = GlobalKey<FormState>();

  // Controllers
  final namaJabatanController = TextEditingController();

  // Observable state variables
  final isLoading = false.obs;
  final isLoadingList = false.obs;
  final isDataFound = false.obs;
  final permissionCuti = false.obs;
  final permissionEksepsi = false.obs;
  final permissionAllCuti = false.obs;
  final permissionAllEksepsi = false.obs;
  final permissionInsentif = false.obs;
  final permissionAtk = false.obs;
  final permissionAllInsentif = false.obs;
  final permissionSuratKeluar = false.obs;
  final permissionManagementData = false.obs;

  // Data jabatan yang sedang diedit
  final currentJabatanId = ''.obs;
  final currentJabatanName = ''.obs;

  // List jabatan
  final jabatanList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadJabatanList();
  }

  // Delete Jabatan
  Future<void> deleteJabatan() async {
    if (currentJabatanId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Tidak ada jabatan yang dipilih untuk dihapus',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Konfirmasi hapus
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus jabatan "${currentJabatanName.value}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      isLoading.value = true;

      await SupabaseService.instance.client
          .from('jabatan')
          .delete()
          .eq('id', currentJabatanId.value);

      Get.snackbar(
        'Berhasil',
        'Jabatan berhasil dihapus',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      // Refresh list dan kembali ke daftar
      await loadJabatanList();
      resetToList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus jabatan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    namaJabatanController.dispose();
    super.onClose();
  }

  // Load semua jabatan dari database
  Future<void> loadJabatanList() async {
    isLoadingList.value = true;

    try {
      final result = await SupabaseService.instance.client
          .from('jabatan')
          .select()
          .order('nama', ascending: true); // Sorting A-Z

      jabatanList.value = List<Map<String, dynamic>>.from(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data jabatan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingList.value = false;
    }
  }

  // Select jabatan untuk diedit
  void selectJabatan(Map<String, dynamic> jabatan) {
    currentJabatanId.value = jabatan['id'];
    currentJabatanName.value = jabatan['nama'];
    namaJabatanController.text = jabatan['nama'];
    permissionCuti.value = jabatan['permissionCuti'] ?? false;
    permissionEksepsi.value = jabatan['permissionEksepsi'] ?? false;
    permissionAllCuti.value = jabatan['permissionAllCuti'] ?? false;
    permissionAllEksepsi.value = jabatan['permissionAllEksepsi'] ?? false;
    permissionInsentif.value = jabatan['permissionInsentif'] ?? false;
    permissionAtk.value = jabatan['permissionAtk'] ?? false;
    permissionAllInsentif.value = jabatan['permissionAllInsentif'] ?? false;
    permissionSuratKeluar.value = jabatan['permissionSuratKeluar'] ?? false;
    permissionManagementData.value = jabatan['permissionManagementData'] ?? false;
    isDataFound.value = true;
  }

  // Toggle permission states
  void togglePermissionCuti(bool value) {
    permissionCuti.value = value;
  }

  void togglePermissionEksepsi(bool value) {
    permissionEksepsi.value = value;
  }

  void togglePermissionAllCuti(bool value) {
    permissionAllCuti.value = value;
  }

  void togglePermissionAllEksepsi(bool value) {
    permissionAllEksepsi.value = value;
  }

  void togglePermissionInsentif(bool value) {
    permissionInsentif.value = value;
  }

  void togglePermissionAtk(bool value) {
    permissionAtk.value = value;
  }

  void togglePermissionAllInsentif(bool value) {
    permissionAllInsentif.value = value;
  }

  void togglePermissionSuratKeluar(bool value) {
    permissionSuratKeluar.value = value;
  }

  void togglePermissionManagementData(bool value) {
    permissionManagementData.value = value;
  }

  // Update Jabatan
  Future<void> updateJabatan() async {
    if (editJabatanFormKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        // Cek duplikasi nama saat update (hindari nama sama pada id berbeda)
        final newName = namaJabatanController.text.trim();
        final existing = await SupabaseService.instance.client
            .from('jabatan')
            .select('id,nama');
        final duplicate = List<Map<String, dynamic>>.from(existing).any(
          (row) => (row['id'] ?? '') != currentJabatanId.value &&
              (row['nama'] ?? '')
                  .toString()
                  .trim()
                  .toLowerCase() ==
                  newName.toLowerCase(),
        );

        if (duplicate) {
          Get.snackbar(
            'Duplikasi Nama',
            'Nama jabatan sudah digunakan oleh entri lain.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
          return;
        }

        // Update jabatan data in Supabase
        await SupabaseService.instance.client
            .from('jabatan')
            .update({
              'nama': namaJabatanController.text.trim(),
              'permissionCuti': permissionCuti.value,
              'permissionEksepsi': permissionEksepsi.value,
              'permissionAllCuti': permissionAllCuti.value,
              'permissionAllEksepsi': permissionAllEksepsi.value,
              'permissionInsentif': permissionInsentif.value,
              'permissionAtk': permissionAtk.value,
              'permissionAllInsentif': permissionAllInsentif.value,
              'permissionSuratKeluar': permissionSuratKeluar.value,
              'permissionManagementData': permissionManagementData.value,
            })
            .eq('id', currentJabatanId.value);

        Get.snackbar(
          'Berhasil',
          'Data jabatan berhasil diperbarui!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );

        // Refresh list dan clear form
        await loadJabatanList();
        clearForm();

        // Go back to data management page
        Get.back();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal memperbarui data jabatan: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Clear Form
  void clearForm() {
    namaJabatanController.clear();
    permissionCuti.value = false;
    permissionEksepsi.value = false;
    permissionAllCuti.value = false;
    permissionAllEksepsi.value = false;
    permissionInsentif.value = false;
    permissionAtk.value = false;
    permissionAllInsentif.value = false;
    permissionSuratKeluar.value = false;
    permissionManagementData.value = false;
    isDataFound.value = false;
    currentJabatanId.value = '';
    currentJabatanName.value = '';
  }

  // Reset to list state
  void resetToList() {
    namaJabatanController.clear();
    permissionCuti.value = false;
    permissionEksepsi.value = false;
    permissionAllCuti.value = false;
    permissionAllEksepsi.value = false;
    permissionInsentif.value = false;
    permissionAtk.value = false;
    permissionAllInsentif.value = false;
    permissionSuratKeluar.value = false;
    permissionManagementData.value = false;
    isDataFound.value = false;
    currentJabatanId.value = '';
    currentJabatanName.value = '';
  }

  // Form Validators
  String? validateNamaJabatan(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama jabatan tidak boleh kosong';
    }
    if (value.length < 2) {
      return 'Nama jabatan minimal 2 karakter';
    }
    return null;
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadJabatanList();
  }
}
