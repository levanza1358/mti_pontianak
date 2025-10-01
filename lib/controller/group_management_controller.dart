import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';

class GroupManagementController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Tab controller
  late TabController tabController;

  // Form keys
  final addGroupFormKey = GlobalKey<FormState>();
  final editGroupFormKey = GlobalKey<FormState>();

  // Form controllers
  final addNamaGroupController = TextEditingController();
  final editNamaGroupController = TextEditingController();

  // Observable state variables
  final isLoadingAdd = false.obs;
  final isLoadingEdit = false.obs;
  final isLoadingList = false.obs;
  final groupList = <Map<String, dynamic>>[].obs;
  final selectedGroupId = Rxn<int>();
  final currentGroupName = ''.obs;
  final showEditForm = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    loadGroupList();
  }

  @override
  void onClose() {
    tabController.dispose();
    addNamaGroupController.dispose();
    editNamaGroupController.dispose();
    super.onClose();
  }

  // Load group list
  Future<void> loadGroupList() async {
    try {
      isLoadingList.value = true;

      final response = await SupabaseService.instance.client
          .from('group')
          .select('*')
          .order('created_at', ascending: false);

      groupList.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data group: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingList.value = false;
    }
  }

  // Form validation
  String? validateNamaGroup(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama group wajib diisi';
    }
    return null;
  }

  // ADD GROUP FUNCTIONS
  Future<void> submitAddForm() async {
    if (!addGroupFormKey.currentState!.validate()) {
      return;
    }

    try {
      isLoadingAdd.value = true;

      // Prepare data for insertion
      final groupData = {
        'nama': addNamaGroupController.text.trim(),
        'created_at': DateTime.now().toIso8601String(),
      };

      // Insert to database
      await SupabaseService.instance.client
          .from('group')
          .insert(groupData)
          .select()
          .single();

      // Show success message
      Get.snackbar(
        'Berhasil',
        'Group berhasil ditambahkan',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      // Clear form and refresh list
      clearAddForm();
      await loadGroupList();

      // Switch to edit tab to see the result
      tabController.animateTo(1);
    } catch (e) {
      // Show error message
      Get.snackbar(
        'Error',
        'Gagal menambahkan group: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingAdd.value = false;
    }
  }

  void clearAddForm() {
    addNamaGroupController.clear();
    addGroupFormKey.currentState?.reset();
  }

  // EDIT GROUP FUNCTIONS
  void selectGroup(Map<String, dynamic> group) {
    selectedGroupId.value = group['id'];
    currentGroupName.value = group['nama'] ?? '';
    editNamaGroupController.text = group['nama'] ?? '';
    showEditForm.value = true;
  }

  void resetToList() {
    showEditForm.value = false;
    selectedGroupId.value = null;
    currentGroupName.value = '';
    editNamaGroupController.clear();
    editGroupFormKey.currentState?.reset();
  }

  Future<void> updateGroup() async {
    if (!editGroupFormKey.currentState!.validate()) {
      return;
    }

    if (selectedGroupId.value == null) {
      Get.snackbar(
        'Error',
        'Tidak ada group yang dipilih',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoadingEdit.value = true;

      // Prepare data for update
      final updateData = {'nama': editNamaGroupController.text.trim()};

      // Update in database
      await SupabaseService.instance.client
          .from('group')
          .update(updateData)
          .eq('id', selectedGroupId.value!);

      // Show success message
      Get.snackbar(
        'Berhasil',
        'Group berhasil diperbarui',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      // Refresh list and reset form
      await loadGroupList();
      resetToList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui group: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingEdit.value = false;
    }
  }

  Future<void> deleteGroup(int groupId, String groupName) async {
    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus group "$groupName"?'),
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
      isLoadingList.value = true;

      // Delete from database
      await SupabaseService.instance.client
          .from('group')
          .delete()
          .eq('id', groupId);

      // Show success message
      Get.snackbar(
        'Berhasil',
        'Group berhasil dihapus',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      // Refresh list
      await loadGroupList();

      // Reset form if the deleted group was selected
      if (selectedGroupId.value == groupId) {
        resetToList();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus group: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingList.value = false;
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadGroupList();
  }

  // Refresh group data for other controllers
  Future<void> refreshGroupData() async {
    await loadGroupList();
  }
}
