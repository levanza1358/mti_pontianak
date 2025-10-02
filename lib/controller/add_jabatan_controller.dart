import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';

class AddJabatanController extends GetxController {
  // Form key
  final jabatanFormKey = GlobalKey<FormState>();

  // Form controllers
  final namaJabatanController = TextEditingController();

  // Observable state variables
  final isLoading = false.obs;
  final permissionCuti = false.obs;
  final permissionEksepsi = false.obs;
  final permissionAllCuti = false.obs;
  final permissionAllEksepsi = false.obs;
  final permissionInsentif = false.obs;
  final permissionAtk = false.obs;
  final permissionAllInsentif = false.obs;
  final permissionSuratKeluar = false.obs;
  final permissionManagementData = false.obs;

  @override
  void onClose() {
    namaJabatanController.dispose();
    super.onClose();
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

  // Submit Jabatan Form
  Future<void> submitJabatanForm() async {
    if (jabatanFormKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        final namaBaru = namaJabatanController.text.trim();

        // Cek duplikasi nama jabatan (trim + case-insensitive)
        final existing = await SupabaseService.instance.client
            .from('jabatan')
            .select('id,nama');
        final exists = List<Map<String, dynamic>>.from(existing).any(
          (row) => (row['nama'] ?? '')
              .toString()
              .trim()
              .toLowerCase() ==
              namaBaru.toLowerCase(),
        );
        if (exists) {
          Get.snackbar(
            'Duplikasi Nama',
            'Nama jabatan sudah ada dan tidak boleh duplikat.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
          return;
        }

        // Insert jabatan data to Supabase
        await SupabaseService.instance.insertData('jabatan', {
          'nama': namaBaru,
          'permissionCuti': permissionCuti.value,
          'permissionEksepsi': permissionEksepsi.value,
          'permissionAllCuti': permissionAllCuti.value,
          'permissionAllEksepsi': permissionAllEksepsi.value,
          'permissionInsentif': permissionInsentif.value,
          'permissionAtk': permissionAtk.value,
          'permissionAllInsentif': permissionAllInsentif.value,
          'permissionSuratKeluar': permissionSuratKeluar.value,
          'permissionManagementData': permissionManagementData.value,
        });

        // Show success message
        Get.snackbar(
          'Berhasil',
          'Jabatan berhasil ditambahkan!',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );

        // Clear form
        clearForm();

        // Go back to data management page
        Get.back();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal menambahkan jabatan: $e',
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
}
