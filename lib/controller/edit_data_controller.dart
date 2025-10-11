import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';

class EditDataController extends GetxController {
  // Form key
  final editDataFormKey = GlobalKey<FormState>();

  // Controllers
  final searchController = TextEditingController();
  final nameController = TextEditingController();
  final nrpController = TextEditingController();
  final passwordController = TextEditingController();
  final sisaCutiController = TextEditingController();

  // Dropdown data
  final jabatanList = <Map<String, dynamic>>[].obs;
  final groupList = <Map<String, dynamic>>[].obs;
  final selectedJabatan = Rxn<String>();
  final selectedStatus = Rxn<String>();
  final selectedGroup = Rxn<String>();
  final selectedStatusGroup = Rxn<String>();

  // Observable state variables
  final isLoading = false.obs;
  final isLoadingList = false.obs;
  final isLoadingJabatan = false.obs;
  final isLoadingGroup = false.obs;
  final isDataFound = false.obs;
  final isPasswordVisible = false.obs;

  // Dropdown options
  final statusOptions = ['Operasional', 'Non Operasional'];
  final statusGroupOptions = ['Atasan', 'Bawahan'];

  // Data pegawai yang sedang diedit
  final currentUserId = ''.obs;
  final currentUserName = ''.obs;

  // List pegawai
  final pegawaiList = <Map<String, dynamic>>[].obs;
  final filteredPegawaiList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPegawaiList();
    loadJabatanList();
    loadGroupList();

    // Setup search listener
    searchController.addListener(_filterPegawai);
  }

  // Load group list from database
  Future<void> loadGroupList() async {
    isLoadingGroup.value = true;
    try {
      final result = await SupabaseService.instance.client
          .from('group')
          .select()
          .order('nama', ascending: true);

      groupList.value = List<Map<String, dynamic>>.from(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data group: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingGroup.value = false;
    }
  }

  // Delete Pegawai
  Future<void> deletePegawai() async {
    if (currentUserId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Tidak ada pegawai yang dipilih untuk dihapus',
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
        content: Text('Apakah Anda yakin ingin menghapus pegawai "${currentUserName.value}"?'),
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
          .from('users')
          .delete()
          .eq('id', currentUserId.value);

      Get.snackbar(
        'Berhasil',
        'Pegawai berhasil dihapus',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      // Refresh list dan kembali ke daftar
      await loadPegawaiList();
      resetToList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus pegawai: $e',
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
    searchController.dispose();
    nameController.dispose();
    nrpController.dispose();
    passwordController.dispose();
    sisaCutiController.dispose();
    super.onClose();
  }

  // Load semua pegawai dari database
  Future<void> loadPegawaiList() async {
    isLoadingList.value = true;

    try {
      final result = await SupabaseService.instance.client
          .from('users')
          .select()
          .order('name', ascending: true); // Sorting A-Z by name

      pegawaiList.value = List<Map<String, dynamic>>.from(result);
      filteredPegawaiList.value = List<Map<String, dynamic>>.from(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data pegawai: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingList.value = false;
    }
  }

  // Load jabatan list from database
  Future<void> loadJabatanList() async {
    isLoadingJabatan.value = true;
    try {
      final result = await SupabaseService.instance.client
          .from('jabatan')
          .select()
          .order('nama', ascending: true);

      // Normalisasi nama (trim) dan hilangkan duplikat berdasarkan field 'nama'
      final raw = List<Map<String, dynamic>>.from(result);
      final seen = <String>{};
      final deduped = <Map<String, dynamic>>[];
      for (final row in raw) {
        final nama = (row['nama'] ?? '').toString().trim();
        if (nama.isEmpty) continue; // skip entri kosong
        if (seen.contains(nama)) continue; // skip duplikat
        seen.add(nama);
        // Simpan kembali nama yang sudah dinormalisasi
        deduped.add({...row, 'nama': nama});
      }
      jabatanList.value = deduped;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data jabatan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingJabatan.value = false;
    }
  }

  // Filter pegawai berdasarkan pencarian nama/NRP
  void _filterPegawai() {
    final query = searchController.text.toLowerCase().trim();

    if (query.isEmpty) {
      filteredPegawaiList.value = List<Map<String, dynamic>>.from(pegawaiList);
    } else {
      filteredPegawaiList.value = pegawaiList.where((pegawai) {
        final name = pegawai['name']?.toString().toLowerCase() ?? '';
        final nrp = pegawai['nrp']?.toString().toLowerCase() ?? '';

        return name.contains(query) || nrp.contains(query);
      }).toList();
    }
  }

  // Clear search
  void clearSearch() {
    searchController.clear();
    filteredPegawaiList.value = List<Map<String, dynamic>>.from(pegawaiList);
  }

  // Select pegawai untuk diedit
  void selectPegawai(Map<String, dynamic> pegawai) {
    currentUserId.value = pegawai['id'];
    currentUserName.value = pegawai['name'] ?? '';
    nameController.text = pegawai['name'] ?? '';
    nrpController.text = pegawai['nrp'] ?? '';
    // Normalisasi jabatan agar selaras dengan daftar (trim)
    selectedJabatan.value = (pegawai['jabatan'] as String?)?.trim();
    selectedStatus.value = pegawai['status'];
    selectedGroup.value = pegawai['group'];
    selectedStatusGroup.value = pegawai['status_group'];
    sisaCutiController.text = (pegawai['sisa_cuti'] ?? 0).toString();
    passwordController.clear(); // Don't show existing password
    isDataFound.value = true;
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Update Pegawai
  Future<void> updatePegawai() async {
    if (editDataFormKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        Map<String, dynamic> updateData = {
          'name': nameController.text.trim(),
          'jabatan': selectedJabatan.value,
          'status': selectedStatus.value,
          'group': selectedGroup.value,
          'status_group': selectedStatusGroup.value,
          'sisa_cuti': int.tryParse(sisaCutiController.text.trim()) ?? 0,
        };

        // Only update password if provided
        if (passwordController.text.trim().isNotEmpty) {
          updateData['password'] = passwordController.text.trim();
        }

        // Update pegawai data in Supabase
        await SupabaseService.instance.client
            .from('users')
            .update(updateData)
            .eq('id', currentUserId.value);

        Get.snackbar(
          'Berhasil',
          'Data pegawai berhasil diperbarui!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );

        // Refresh list dan clear form
        await loadPegawaiList();
        clearForm();

        // Go back to data management page
        Get.back();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal memperbarui data pegawai: $e',
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
    nameController.clear();
    nrpController.clear();
    passwordController.clear();
    sisaCutiController.clear();
    selectedJabatan.value = null;
    selectedStatus.value = null;
    selectedGroup.value = null;
    selectedStatusGroup.value = null;
    isDataFound.value = false;
    currentUserId.value = '';
    currentUserName.value = '';
    isPasswordVisible.value = false;
  }

  // Reset to list state
  void resetToList() {
    nameController.clear();
    nrpController.clear();
    passwordController.clear();
    sisaCutiController.clear();
    selectedJabatan.value = null;
    selectedStatus.value = null;
    selectedGroup.value = null;
    selectedStatusGroup.value = null;
    isDataFound.value = false;
    currentUserId.value = '';
    currentUserName.value = '';
    isPasswordVisible.value = false;
  }

  // Form Validators
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.length < 2) {
      return 'Nama minimal 2 karakter';
    }
    return null;
  }

  String? validateJabatan(String? value) {
    if (selectedJabatan.value == null) {
      return 'Jabatan tidak boleh kosong';
    }
    return null;
  }

  String? validateStatus(String? value) {
    if (selectedStatus.value == null) {
      return 'Status tidak boleh kosong';
    }
    return null;
  }

  String? validateGroup(String? value) {
    if (selectedGroup.value == null) {
      return 'Group tidak boleh kosong';
    }
    return null;
  }

  String? validateStatusGroup(String? value) {
    if (selectedStatusGroup.value == null) {
      return 'Status Group tidak boleh kosong';
    }
    return null;
  }

  String? validatePassword(String? value) {
    // Password optional, but if provided must be >= 6 chars
    if (value != null && value.isNotEmpty && value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  String? validateSisaCuti(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Sisa cuti tidak boleh kosong';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null) {
      return 'Sisa cuti harus berupa angka';
    }
    if (parsed < 0) {
      return 'Sisa cuti tidak boleh negatif';
    }
    return null;
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadPegawaiList();
  }
}
