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

  void showDetail(Map<String, dynamic> item) {
    final nama = (item['nama'] ?? '-') as String;
    final alasan = (item['alasan_cuti'] ?? '-') as String;
    final lama = item['lama_cuti']?.toString() ?? '-';
    final tanggalPengajuan = (item['tanggal_pengajuan'] ?? '')?.toString() ?? '';
    final tanggalList = (item['list_tanggal_cuti'] ?? '') as String;
    final sisa = item['sisa_cuti']?.toString() ?? '-';
    final locked = (item['kunci_cuti'] ?? false) as bool;

    Get.dialog(
      AlertDialog(
        title: const Text('Detail Cuti'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Nama', nama),
            _row('Tanggal Pengajuan', tanggalPengajuan.isEmpty ? '-' : tanggalPengajuan),
            _row('Tanggal Cuti', tanggalList.isEmpty ? '-' : tanggalList.replaceAll(',', ', ')),
            _row('Lama', '$lama hari'),
            _row('Sisa Cuti Setelah', sisa),
            _row('Status Kunci', locked ? 'Terkunci' : 'Terbuka'),
            const SizedBox(height: 8),
            const Text('Alasan:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(alasan.isEmpty ? '-' : alasan),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Tutup')),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
