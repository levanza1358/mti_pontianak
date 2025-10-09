import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class SemuaDataCutiController extends GetxController {
  final isLoadingList = false.obs;
  final cutiList = <Map<String, dynamic>>[].obs;
  // State pemilahan per-bulan (default ke bulan berjalan)
  final selectedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1).obs;

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

  // Navigasi bulan
  void nextMonth() {
    final current = selectedMonth.value;
    selectedMonth.value = DateTime(current.year, current.month + 1, 1);
  }

  void prevMonth() {
    final current = selectedMonth.value;
    selectedMonth.value = DateTime(current.year, current.month - 1, 1);
  }

  String monthLabel() {
    const bulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    final m = selectedMonth.value.month;
    final y = selectedMonth.value.year;
    return '${bulan[m - 1]} $y';
  }

  // Filter data berdasarkan bulan terpilih
  List<Map<String, dynamic>> get cutiForSelectedMonth {
    final sm = selectedMonth.value;
    return cutiList.where((item) {
      DateTime? d;
      final pengajuan = item['tanggal_pengajuan']?.toString();
      if (pengajuan != null && pengajuan.isNotEmpty) {
        d = DateTime.tryParse(pengajuan);
      }
      // Fallback: pakai tanggal pertama dari list_tanggal_cuti jika ada
      if (d == null) {
        final listTanggalStr = item['list_tanggal_cuti']?.toString() ?? '';
        if (listTanggalStr.isNotEmpty) {
          final firstDateStr = listTanggalStr.split(',').first.trim();
          d = DateTime.tryParse(firstDateStr);
        }
      }
      if (d == null) return false;
      return d.year == sm.year && d.month == sm.month;
    }).toList();
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

  // Force delete cuti regardless of lock status and restore user's leave balance
  Future<void> forceDeleteCuti(Map<String, dynamic> item) async {
    try {
      final cutiId = item['id'];
      final userId = item['users_id'];

      if (cutiId == null) {
        Get.snackbar(
          'Error',
          'ID cuti tidak ditemukan',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // Hitung jumlah hari untuk dikembalikan ke saldo
      int daysToRestore = 0;
      final dateString = (item['list_tanggal_cuti'] ?? '') as String;
      if (dateString.isNotEmpty) {
        final dates = dateString.split(',').map((e) => e.trim()).toList();
        daysToRestore = dates.length;
      } else {
        // Fallback ke lama_cuti jika list_tanggal_cuti kosong
        final lama = item['lama_cuti'];
        if (lama is int) {
          daysToRestore = lama;
        } else if (lama is String) {
          daysToRestore = int.tryParse(lama) ?? 0;
        }
      }

      // 1. Hapus record cuti
      await SupabaseService.instance.client
          .from('cuti')
          .delete()
          .eq('id', cutiId);

      // 2. Kembalikan saldo cuti user bila memungkinkan
      if (userId != null && daysToRestore > 0) {
        final userResult = await SupabaseService.instance.client
            .from('users')
            .select('sisa_cuti')
            .eq('id', userId)
            .single();

        final currentBalance = (userResult['sisa_cuti'] ?? 0) as int;
        final newBalance = currentBalance + daysToRestore;

        await SupabaseService.instance.client
            .from('users')
            .update({'sisa_cuti': newBalance})
            .eq('id', userId);
      }

      // 3. Refresh list
      await refreshData();

      Get.snackbar(
        'Berhasil',
        'Cuti dihapus paksa dan ${daysToRestore > 0 ? '$daysToRestore hari' : 'saldo'} dikembalikan',
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

  // Confirmation dialog for force delete
  Future<void> showForceDeleteConfirmation(Map<String, dynamic> item) async {
    final nama = (item['nama'] ?? '-') as String;
    final tanggalList = (item['list_tanggal_cuti'] ?? '') as String;
    final alasan = (item['alasan_cuti'] ?? '-') as String;

    // Hitung durasi
    int daysCount = 0;
    if (tanggalList.isNotEmpty) {
      daysCount = tanggalList.split(',').map((e) => e.trim()).length;
    } else {
      final lama = item['lama_cuti'];
      if (lama is int) {
        daysCount = lama;
      } else if (lama is String) {
        daysCount = int.tryParse(lama) ?? 0;
      }
    }

    await Get.dialog(
      AlertDialog(
        title: const Text('Hapus Paksa Cuti'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${nama.isEmpty ? '-' : nama}'),
            const SizedBox(height: 4),
            Text('Tanggal: ${tanggalList.isEmpty ? '-' : tanggalList.replaceAll(',', ', ')}'),
            const SizedBox(height: 4),
            Text('Durasi: ${daysCount > 0 ? '$daysCount hari' : '-'}'),
            const SizedBox(height: 4),
            Text('Alasan: ${alasan.isEmpty ? '-' : alasan}'),
            const SizedBox(height: 10),
            const Text(
              'Tindakan ini akan menghapus data meskipun terkunci dan mengembalikan saldo cuti pengguna.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back();
              forceDeleteCuti(item);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus Paksa'),
          ),
        ],
      ),
    );
  }
}
