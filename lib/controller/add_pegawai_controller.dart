import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';

class AddPegawaiController extends GetxController {
  // Form key
  final pegawaiFormKey = GlobalKey<FormState>();

  // Form controllers
  final nameController = TextEditingController();
  final nrpController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable state variables
  final isLoading = false.obs;
  final isLoadingJabatan = false.obs;
  final isLoadingGroup = false.obs;
  final isPasswordVisible = false.obs;

  // Dropdown data
  final jabatanList = <Map<String, dynamic>>[].obs;
  final groupList = <Map<String, dynamic>>[].obs;
  final selectedJabatan = Rxn<String>();
  final selectedStatus = Rxn<String>();
  final selectedGroup = Rxn<String>();
  final selectedStatusGroup = Rxn<String>();

  // Dropdown options
  final statusOptions = ['Operasional', 'Non Operasional'];
  final statusGroupOptions = ['Atasan', 'Bawahan'];

  @override
  void onInit() {
    super.onInit();
    loadJabatanList();
    loadGroupList();
  }

  @override
  void onClose() {
    nameController.dispose();
    nrpController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Load jabatan list from database
  Future<void> loadJabatanList() async {
    isLoadingJabatan.value = true;
    try {
      final result = await SupabaseService.instance.client
          .from('jabatan')
          .select()
          .order('nama', ascending: true);

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
      isLoadingJabatan.value = false;
    }
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

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Submit Pegawai Form
  Future<void> submitPegawaiForm() async {
    if (pegawaiFormKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        // Prepare user data
        final userData = {
          'nrp': nrpController.text.trim(),
          'password': passwordController.text,
          'name': nameController.text.trim(),
          'jabatan': selectedJabatan.value,
          'status': selectedStatus.value,
          'group':
              selectedGroup.value, // using group_ to avoid SQL reserved word
          'status_group': selectedStatusGroup.value,
        };

        // Insert user data directly to avoid SupabaseService createUser limitations
        await SupabaseService.instance.client.from('users').insert(userData);

        // Show success message with animation
        Get.snackbar(
          'Berhasil',
          'Pegawai berhasil ditambahkan!',
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          animationDuration: const Duration(milliseconds: 500),
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          shouldIconPulse: true,
          mainButton: TextButton(
            onPressed: () => Get.closeCurrentSnackbar(),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        );

        // Clear form
        clearForm();

        // Go back to data management page
        Get.back();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal menambahkan pegawai: $e',
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
    selectedJabatan.value = null;
    selectedStatus.value = null;
    selectedGroup.value = null;
    selectedStatusGroup.value = null;
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

  String? validateNrp(String? value) {
    if (value == null || value.isEmpty) {
      return 'NRP tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'NRP minimal 6 karakter';
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
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  // Helper method for consistent input decoration
  InputDecoration buildInputDecoration(BuildContext context, String hintText) {
    final theme = Theme.of(context);
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: theme.textTheme.bodyMedium?.color?.withValues(
          alpha: 153,
        ), // 0.6 * 255 ≈ 153
      ),
      filled: true,
      fillColor: theme.brightness == Brightness.dark
          ? theme.cardColor.withValues(alpha: 128) // 0.5 * 255 ≈ 128
          : Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  // Helper method for consistent label styling
  Widget buildLabel(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: theme.textTheme.bodyLarge?.color,
      ),
    );
  }

  // Refresh group data (can be called when groups are updated)
  Future<void> refreshGroupData() async {
    await loadGroupList();
  }
}
