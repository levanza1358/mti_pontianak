import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';

class SemuaDataEksepsiController extends GetxController {
  final isLoadingList = false.obs;
  final eksepsiList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllEksepsi();
  }

  Future<void> fetchAllEksepsi() async {
    try {
      isLoadingList.value = true;

      final client = SupabaseService.instance.client;

      List<dynamic> result;
      try {
        // Coba ambil dengan join tabel tanggal
        result = await client
            .from('eksepsi')
            .select('''
              *,
              eksepsi_tanggal (
                tanggal_eksepsi,
                urutan,
                alasan_eksepsi
              )
            ''')
            .order('tanggal_pengajuan', ascending: false);
      } catch (_) {
        // Fallback tanpa join
        result = await client
            .from('eksepsi')
            .select()
            .order('tanggal_pengajuan', ascending: false);
      }

      final list = List<Map<String, dynamic>>.from(result);

      // Kumpulkan user_id untuk pemetaan nama
      final userIds = list.map((e) => e['user_id']).whereType<String>().toSet();
      final Map<String, Map<String, dynamic>> userMap = {};
      if (userIds.isNotEmpty) {
        try {
          final users = await client
              .from('users')
              .select('id, name, nrp')
              .inFilter('id', userIds.toList());
          for (final u in List<Map<String, dynamic>>.from(users)) {
            userMap[u['id'] as String] = u;
          }
        } catch (_) {
          // Abaikan jika gagal; tampilkan user_id saja
        }
      }

      // Transformasi data: rangkum tanggal, ambil alasan pertama
      final transformed = list.map((item) {
        final tanggalList = (item['eksepsi_tanggal'] as List? ?? [])
            .map((t) => (t['tanggal_eksepsi'] ?? '').toString())
            .where((s) => s.isNotEmpty)
            .toList()
          ..sort();

        final firstAlasan = (item['eksepsi_tanggal'] as List? ?? []).isNotEmpty
            ? (((item['eksepsi_tanggal'] as List)[0])['alasan_eksepsi'] ?? '').toString()
            : '';

        final userId = (item['user_id'] ?? '').toString();
        final user = userMap[userId];

        return {
          ...item,
          'user_name': user != null ? (user['name'] ?? '') : null,
          'user_nrp': user != null ? (user['nrp'] ?? '') : null,
          'list_tanggal_eksepsi': tanggalList.join(', '),
          'jumlah_hari': tanggalList.length,
          'alasan_eksepsi': firstAlasan,
        };
      }).toList();

      eksepsiList.value = List<Map<String, dynamic>>.from(transformed);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat semua data eksepsi: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingList.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchAllEksepsi();
  }

  void showDetail(Map<String, dynamic> item) {
    final userName = (item['user_name'] ?? '') as String;
    final userNrp = (item['user_nrp'] ?? '') as String;
    final userId = (item['user_id'] ?? '')?.toString() ?? '';
    final jenis = (item['jenis_eksepsi'] ?? '-') as String;
    final tanggalPengajuan = (item['tanggal_pengajuan'] ?? '')?.toString() ?? '';
    final tanggalList = (item['list_tanggal_eksepsi'] ?? '') as String;
    final jumlahHari = item['jumlah_hari']?.toString() ?? '-';
    final alasan = (item['alasan_eksepsi'] ?? '-') as String;

    final titleText = userName.isNotEmpty
        ? userName
        : (userNrp.isNotEmpty ? userNrp : (userId.isNotEmpty ? userId : '-'));

    Get.dialog(
      AlertDialog(
        title: const Text('Detail Eksepsi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Pengaju', titleText),
            _row('Jenis', jenis),
            _row('Tanggal Pengajuan', tanggalPengajuan.isEmpty ? '-' : tanggalPengajuan),
            _row('Tanggal Eksepsi', tanggalList.isEmpty ? '-' : tanggalList.replaceAll(',', ', ')),
            _row('Jumlah Hari', '$jumlahHari hari'),
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
