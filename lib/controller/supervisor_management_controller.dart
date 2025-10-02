import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';

class SupervisorManagementController extends GetxController {
  // Tab management
  var selectedTab = 0.obs;
  
  // Loading states
  var isLoading = false.obs;
  var isLoadingList = false.obs;
  var isLoadingEdit = false.obs;
  
  // Form controllers for adding supervisor
  final namaSupervisorController = TextEditingController();
  final jabatanSupervisorController = TextEditingController();
  var selectedJenisSupervisor = ''.obs;
  
  // Form controllers for editing supervisor
  final editNamaSupervisorController = TextEditingController();
  final editJabatanSupervisorController = TextEditingController();
  var selectedEditJenisSupervisor = ''.obs;
  
  // Edit form state
  var showEditForm = false.obs;
  var currentSupervisorId = 0.obs;
  var currentSupervisorName = ''.obs;
  
  // Data
  var supervisorList = <Map<String, dynamic>>[].obs;
  
  // Dropdown options - sesuai dengan constraint di database
  final jenisSupervisorList = [
    'Penunjang',
    'Logistik',
    'Manager_PDS',
  ];
  
  // Supabase service
  final SupabaseService _supabaseService = SupabaseService.instance;
  
  @override
  void onInit() {
    super.onInit();
    fetchSupervisors();
  }
  
  @override
  void onClose() {
    namaSupervisorController.dispose();
    jabatanSupervisorController.dispose();
    editNamaSupervisorController.dispose();
    editJabatanSupervisorController.dispose();
    super.onClose();
  }
  
  // Fetch supervisors from Supabase
  Future<void> fetchSupervisors() async {
    try {
      isLoadingList.value = true;
      print('Fetching supervisors from Supabase...');
      
      final response = await _supabaseService.client
          .from('supervisor')
          .select('*')
          .order('created_at', ascending: false);
      
      print('Supervisors fetched: ${response.length}');
      supervisorList.value = List<Map<String, dynamic>>.from(response);
      
    } catch (e) {
      print('Error fetching supervisors: $e');
      Get.snackbar('Error', 'Gagal mengambil data supervisor: $e');
    } finally {
      isLoadingList.value = false;
    }
  }
  
  // Add new supervisor
  Future<void> addSupervisor() async {
    if (!_validateAddForm()) return;
    
    try {
      isLoading.value = true;
      
      final data = {
        'nama': namaSupervisorController.text.trim(),
        'jabatan': jabatanSupervisorController.text.trim(),
        'jenis': selectedJenisSupervisor.value,
      };
      
      print('Adding supervisor with data: $data');
      
      await _supabaseService.client
          .from('supervisor')
          .insert(data);
      
      Get.snackbar('Success', 'Supervisor berhasil ditambahkan');
      _clearAddForm();
      await fetchSupervisors();
      
    } catch (e) {
      print('Error adding supervisor: $e');
      Get.snackbar('Error', 'Gagal menambahkan supervisor: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Select supervisor for editing
  void selectSupervisor(Map<String, dynamic> supervisor) {
    print('=== selectSupervisor called ===');
    print('Supervisor data: $supervisor');
    
    currentSupervisorId.value = supervisor['id'] ?? 0;
    currentSupervisorName.value = supervisor['nama'] ?? '';
    
    editNamaSupervisorController.text = supervisor['nama'] ?? '';
    editJabatanSupervisorController.text = supervisor['jabatan'] ?? '';
    selectedEditJenisSupervisor.value = supervisor['jenis_supervisor'] ?? '';
    
    print('Form populated:');
    print('- ID: ${currentSupervisorId.value}');
    print('- Name: ${currentSupervisorName.value}');
    print('- editNamaSupervisorController.text: ${editNamaSupervisorController.text}');
    print('- editJabatanSupervisorController.text: ${editJabatanSupervisorController.text}');
    print('- selectedEditJenisSupervisor.value: ${selectedEditJenisSupervisor.value}');
    
    showEditForm.value = true;
    print('showEditForm set to: ${showEditForm.value}');
  }
  
  // Update supervisor
  Future<void> updateSupervisor() async {
    if (!_validateEditForm()) return;
    
    try {
      isLoadingEdit.value = true;
      
      final data = {
        'nama': editNamaSupervisorController.text.trim(),
        'jabatan': editJabatanSupervisorController.text.trim(),
        'jenis': selectedEditJenisSupervisor.value,
      };
      
      print('Updating supervisor ID ${currentSupervisorId.value} with data: $data');
      
      await _supabaseService.client
          .from('supervisor')
          .update(data)
          .eq('id', currentSupervisorId.value);
      
      Get.snackbar('Success', 'Supervisor berhasil diupdate');
      showEditForm.value = false;
      await fetchSupervisors();
      
    } catch (e) {
      print('Error updating supervisor: $e');
      Get.snackbar('Error', 'Gagal mengupdate supervisor: $e');
    } finally {
      isLoadingEdit.value = false;
    }
  }
  
  // Delete supervisor
  Future<void> deleteSupervisor(int id) async {
    try {
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menghapus supervisor ini?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Hapus'),
            ),
          ],
        ),
      );
      
      if (confirm != true) return;
      
      print('Deleting supervisor ID: $id');
      
      await _supabaseService.client
          .from('supervisor')
          .delete()
          .eq('id', id);
      
      Get.snackbar('Success', 'Supervisor berhasil dihapus');
      await fetchSupervisors();
      
    } catch (e) {
      print('Error deleting supervisor: $e');
      Get.snackbar('Error', 'Gagal menghapus supervisor: $e');
    }
  }
  
  // Refresh data
  Future<void> refreshData() async {
    await fetchSupervisors();
  }
  
  // Validation for add form
  bool _validateAddForm() {
    if (namaSupervisorController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Nama supervisor harus diisi');
      return false;
    }
    
    if (jabatanSupervisorController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Jabatan supervisor harus diisi');
      return false;
    }
    
    if (selectedJenisSupervisor.value.isEmpty) {
      Get.snackbar('Error', 'Jenis supervisor harus dipilih');
      return false;
    }
    
    return true;
  }
  
  // Validation for edit form
  bool _validateEditForm() {
    if (editNamaSupervisorController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Nama supervisor harus diisi');
      return false;
    }
    
    if (editJabatanSupervisorController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Jabatan supervisor harus diisi');
      return false;
    }
    
    if (selectedEditJenisSupervisor.value.isEmpty) {
      Get.snackbar('Error', 'Jenis supervisor harus dipilih');
      return false;
    }
    
    return true;
  }
  
  // Clear add form
  void _clearAddForm() {
    namaSupervisorController.clear();
    jabatanSupervisorController.clear();
    selectedJenisSupervisor.value = '';
  }
}