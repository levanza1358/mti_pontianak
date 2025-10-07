import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class SemuaDataCutiController extends GetxController {
  final isLoadingList = false.obs;
  final cutiList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllCuti();
  }

  Future<void> fetchAllCuti() async {
    try {
      isLoadingList.value = true;

      final result = await SupabaseService.instance.client
          .from('cuti')
          .select()
          .order('tanggal_pengajuan', ascending: false);

      cutiList.value = List<Map<String, dynamic>>.from(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat semua data cuti: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingList.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchAllCuti();
  }

  Color getLockColor(bool? locked) => (locked ?? false) ? Colors.orange : Colors.green;
}

