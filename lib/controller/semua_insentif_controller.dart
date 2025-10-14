// lib/controller/semua_insentif_controller.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mti_pontianak/services/supabase_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SemuaInsentifController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final supabaseService = SupabaseService.instance;
  late TabController tabController;

  // ====== State utama ======
  final insentifPremiList = <Map<String, dynamic>>[].obs;
  final insentifLemburList = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  // ====== Filter tahun & bulan ======
  final selectedYear = DateTime.now().year.obs;
  final selectedMonth = DateTime.now().month.obs;
  final availableYears = <int>{}.obs;

  String get monthYearLabel {
    final dt = DateTime(selectedYear.value, selectedMonth.value, 1);
    return DateFormat('MMMM yyyy', 'id_ID').format(dt);
  }

  // ====== Data terfilter (by tahun+bulan) & total (hitung di controller agar UI enteng) ======
  List<Map<String, dynamic>> get filteredPremiList {
    final y = selectedYear.value, m = selectedMonth.value;
    final list = insentifPremiList.where((item) {
      final yr = _asInt(item['tahun']);
      final mo = _parseDate(item['bulan'])?.month;
      return yr == y && mo == m;
    }).toList()
      ..sort((a, b) {
        final da = _parseDate(a['bulan']);
        final db = _parseDate(b['bulan']);
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return db.compareTo(da);
      });
    return list;
  }

  List<Map<String, dynamic>> get filteredLemburList {
    final y = selectedYear.value, m = selectedMonth.value;
    final list = insentifLemburList.where((item) {
      final yr = _asInt(item['tahun']);
      final mo = _parseDate(item['bulan'])?.month;
      return yr == y && mo == m;
    }).toList()
      ..sort((a, b) {
        final da = _parseDate(a['bulan']);
        final db = _parseDate(b['bulan']);
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return db.compareTo(da);
      });
    return list;
  }

  int get totalPremiForFilter => filteredPremiList.fold<int>(
      0, (s, e) => s + ((e['nominal'] ?? 0) as int));

  int get totalLemburForFilter => filteredLemburList.fold<int>(
      0, (s, e) => s + ((e['nominal'] ?? 0) as int));

  int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse('$v');
  }

  DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    try {
      return DateTime.parse(v.toString());
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    _initializeData();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> _initializeData() async {
    final ok = await supabaseService.testConnection();
    if (!ok) {
      Get.snackbar('Error', 'Tidak dapat terhubung ke server',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    await fetchInsentifPremi();
    await fetchInsentifLembur();
    updateAvailableYears();
  }

  // ====== Fetch data ======
  Future<void> fetchInsentifPremi() async {
    isLoading(true);
    try {
      final data = await supabaseService.getInsentifPremi();
      insentifPremiList.value = data;
    } catch (_) {
      Get.snackbar('Error', 'Gagal mengambil data Insentif Premi',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchInsentifLembur() async {
    isLoading(true);
    try {
      final data = await supabaseService.getInsentifLembur();
      insentifLemburList.value = data;
    } catch (_) {
      Get.snackbar('Error', 'Gagal mengambil data Insentif Lembur',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  // ====== Util ======
  String formatCurrency(int? nominal) {
    if (nominal == null) return 'Rp 0';
    final s = nominal.toString();
    final withDots = s.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $withDots';
  }

  void updateAvailableYears() {
    final years = <int>{};

    for (final item in insentifPremiList) {
      final yr = _asInt(item['tahun']);
      if (yr != null) years.add(yr);
    }
    for (final item in insentifLemburList) {
      final yr = _asInt(item['tahun']);
      if (yr != null) years.add(yr);
    }

    if (years.isEmpty) years.add(DateTime.now().year);
    availableYears.assignAll(years);

    if (!availableYears.contains(selectedYear.value)) {
      final sorted = years.toList()..sort((a, b) => b.compareTo(a));
      selectedYear.value =
          sorted.isNotEmpty ? sorted.first : DateTime.now().year;
    }
  }

  void changeYear(int year) {
    selectedYear.value = year;
    update();
  }

  void prevMonth() {
    var m = selectedMonth.value - 1;
    var y = selectedYear.value;
    if (m < 1) {
      m = 12;
      y -= 1;
    }
    selectedMonth.value = m;
    selectedYear.value = y;
    update();
  }

  void nextMonth() {
    var m = selectedMonth.value + 1;
    var y = selectedYear.value;
    if (m > 12) {
      m = 1;
      y += 1;
    }
    selectedMonth.value = m;
    selectedYear.value = y;
    update();
  }

  Future<void> deleteInsentifItem({
    required Map<String, dynamic> item,
    required String jenis, // 'Premi' atau 'Lembur'
  }) async {
    try {
      final table =
          jenis.toLowerCase() == 'premi' ? 'insentif_premi' : 'insentif_lembur';
      final id = item['id'];
      if (id == null) {
        Get.snackbar('Gagal', 'ID data tidak ditemukan',
            backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }
      await supabaseService.client.from(table).delete().eq('id', id);

      await fetchInsentifPremi();
      await fetchInsentifLembur();
      updateAvailableYears();

      Get.snackbar('Berhasil', 'Data dihapus',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // ===========================================================
  // ===============  IMPORT + PREVIEW + UPSERT  ===============
  // ===========================================================
  Future<void> pickAndImportExcel({
    required String jenis, // 'Premi' atau 'Lembur'
    required int tahun,
    required int bulan,
    BuildContext? context,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['xlsx', 'xls', 'csv'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      final bytes = file.bytes;
      if (bytes == null) {
        Get.snackbar('Gagal', 'Tidak dapat membaca file',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final candidates = <_RowDraft>[];
      final ext = (file.extension ?? '').toLowerCase();

      if (ext == 'xlsx' || ext == 'xls') {
        candidates.addAll(await _parseExcel(bytes));
      } else if (ext == 'csv') {
        candidates.addAll(_parseCsv(String.fromCharCodes(bytes)));
      } else {
        Get.snackbar('Gagal', 'Ekstensi tidak didukung',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final filtered = candidates.where((e) => e.nrp.isNotEmpty).toList();
      if (filtered.isEmpty) {
        Get.snackbar('Tidak ada data', 'Baris valid tidak ditemukan',
            backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }

      // Batch lookup user by NRP
      final nrps = filtered.map((e) => e.nrp).toList();
      final userMap = await supabaseService.getUsersByNRPs(nrps);

      final found = <_PreviewRow>[];
      final missing = <_PreviewRow>[];
      for (final r in filtered) {
        final u = userMap[r.nrp];
        if (u == null) {
          missing.add(_PreviewRow(
              nrp: r.nrp,
              nama: r.nama,
              nominal: r.nominal,
              alasan: 'NRP tidak ditemukan'));
        } else {
          final namaFinal = (u['name'] ?? r.nama).toString();
          found.add(_PreviewRow(
              nrp: r.nrp,
              nama: namaFinal,
              nominal: r.nominal,
              usersId: u['id']));
        }
      }

      await _showPreviewDialog(
        jenis: jenis,
        tahun: tahun,
        bulan: bulan,
        found: found,
        missing: missing,
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal impor: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> _showPreviewDialog({
    required String jenis,
    required int tahun,
    required int bulan,
    required List<_PreviewRow> found,
    required List<_PreviewRow> missing,
  }) async {
    await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (ctx) {
        final total = found.fold<int>(0, (s, e) => s + e.nominal);
        return AlertDialog(
          title: Text('Preview Upload $jenis'),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Siap di-upsert: ${found.length} baris'),
                Text('NRP tidak ditemukan: ${missing.length} baris'),
                const SizedBox(height: 10),
                if (found.isNotEmpty)
                  Text('Contoh data (max 5):',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                if (found.isNotEmpty)
                  ...found.take(5).map((r) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Expanded(child: Text(r.nrp)),
                            Expanded(child: Text(r.nama)),
                            Text(formatCurrency(r.nominal)),
                          ],
                        ),
                      )),
                const SizedBox(height: 10),
                Text('Total nominal (preview): ${formatCurrency(total)}'),
              ],
            ),
          ),
          actions: [
            if (missing.isNotEmpty)
              TextButton.icon(
                icon: const Icon(Icons.download),
                onPressed: () async {
                  await _exportMissingCsv(missing, jenis, tahun, bulan);
                },
                label: const Text('Unduh CSV Error'),
              ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await _commitUpsert(
                    jenis: jenis, tahun: tahun, bulan: bulan, found: found);
              },
              child: const Text('Upsert Sekarang'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _commitUpsert({
    required String jenis,
    required int tahun,
    required int bulan,
    required List<_PreviewRow> found,
  }) async {
    try {
      if (found.isEmpty) {
        Get.snackbar(
            'Tidak ada data', 'Tidak ada baris yang valid untuk di-upsert',
            backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }
      final table = (jenis.toLowerCase() == 'premi')
          ? 'insentif_premi'
          : 'insentif_lembur';
      final bulanStr = _formatYearMonthAsDate(tahun, bulan);

      final rows = found.map((r) {
        return {
          'users_id': r.usersId,
          'nrp': r.nrp,
          'nama': r.nama,
          'nominal': r.nominal,
          'bulan': bulanStr, // DATE (YYYY-MM-01)
          'tahun': tahun, // INTEGER
        };
      }).toList();

      await supabaseService.upsertInsentif(table: table, rows: rows);

      await fetchInsentifPremi();
      await fetchInsentifLembur();
      updateAvailableYears();

      Get.snackbar('Berhasil', 'Upsert ${rows.length} baris ke $jenis',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Gagal upsert: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  String _formatYearMonthAsDate(int tahun, int bulan) {
    final mm = bulan.toString().padLeft(2, '0');
    return '$tahun-$mm-01';
  }

  Future<void> _exportMissingCsv(
      List<_PreviewRow> missing, String jenis, int tahun, int bulan) async {
    final buffer = StringBuffer();
    buffer.writeln('nrp,nama,nominal,alasan,jenis,tahun,bulan');
    for (final r in missing) {
      final safeNama = r.nama.replaceAll('"', '""');
      buffer.writeln(
          '"${r.nrp}","$safeNama",${r.nominal},"${r.alasan}","$jenis",$tahun,$bulan');
    }
    final csv = buffer.toString();

    final dir = await getTemporaryDirectory();
    final f = File('${dir.path}/error_nrp_${jenis}_$tahun-$bulan.csv');
    await f.writeAsString(csv, flush: true);
    await Share.shareXFiles([XFile(f.path)],
        text: 'NRP tidak ditemukan ($jenis $bulan/$tahun)');
  }

  // ===================== PARSER =====================

  int _parseAnyToInt(dynamic val) {
    if (val == null) return 0;

    if (val is num) {
      final d = val.toDouble();
      if (!d.isFinite) return 0;
      final r = d.round();
      return r < 0 ? 0 : r;
    }

    var s = val.toString().trim();
    if (s.isEmpty) return 0;

    // tolak huruf selain e/E
    if (RegExp(r'[a-df-zA-DF-Z]').hasMatch(s)) return 0;

    // notasi sains → buang pemisah lalu parse
    if (RegExp(r'[eE]').hasMatch(s)) {
      final t = s.replaceAll('.', '').replaceAll(',', '');
      final d = double.tryParse(t);
      if (d != null && d.isFinite) {
        final r = d.round();
        return r < 0 ? 0 : r;
      }
    }

    final hasComma = s.contains(',');
    final hasDot = s.contains('.');
    String normalized = s;

    if (hasComma && hasDot) {
      final lastComma = s.lastIndexOf(',');
      final lastDot = s.lastIndexOf('.');
      final commaAsDecimal = lastComma > lastDot;
      normalized = commaAsDecimal
          ? s.replaceAll('.', '').replaceAll(',', '.') // koma desimal
          : s.replaceAll(',', ''); // titik desimal
    } else if (hasComma && !hasDot) {
      normalized = s.replaceAll(',', '');
    } else if (!hasComma && hasDot) {
      final dotCount = RegExp(r'\.').allMatches(s).length;
      normalized = (dotCount > 1) ? s.replaceAll('.', '') : s;
    }

    final d2 = double.tryParse(normalized);
    if (d2 != null && d2.isFinite) {
      final r = d2.floor();
      return r < 0 ? 0 : r;
    }

    final digitsOnly = normalized.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) return 0;
    final n = int.tryParse(digitsOnly) ?? 0;
    return n < 0 ? 0 : n;
  }

  String _normalize(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

  Future<List<_RowDraft>> _parseExcel(Uint8List bytes) async {
    final excel = Excel.decodeBytes(bytes);
    if (excel.tables.isEmpty) return [];
    final sheet = excel.tables[excel.tables.keys.first]!;
    if (sheet.rows.isEmpty) return [];

    final header = sheet.rows.first
        .map((c) => (c?.value?.toString() ?? '').trim())
        .toList();
    int idxNRP = header.indexWhere((h) => _normalize(h).contains('nrp'));
    int idxNama = header.indexWhere((h) => _normalize(h).contains('nama'));
    int idxIns = header.indexWhere((h) =>
        _normalize(h).contains('insentif') ||
        _normalize(h).contains('dibayarkan') ||
        _normalize(h).contains('nominal'));

    if (idxNRP < 0) idxNRP = 0;
    if (idxNama < 0) idxNama = 1;
    if (idxIns < 0) idxIns = 2;

    final out = <_RowDraft>[];
    for (var r = 1; r < sheet.rows.length; r++) {
      final row = sheet.rows[r];

      final nrp = _cellString(row, idxNRP);
      final nama = _cellString(row, idxNama);
      final rawVal =
          (idxIns >= 0 && idxIns < row.length) ? row[idxIns]?.value : null;
      final nominal = _parseAnyToInt(rawVal);

      if (nrp.isEmpty) continue;
      out.add(_RowDraft(nrp: nrp, nama: nama, nominal: nominal));
    }
    return out;
  }

  List<_RowDraft> _parseCsv(String content) {
    final lines = const LineSplitter()
        .convert(content.replaceAll('\r\n', '\n').replaceAll('\r', '\n'))
        .where((l) => l.trim().isNotEmpty)
        .toList();
    if (lines.isEmpty) return [];

    List<String> smartSplit(String line) {
      final res = <String>[];
      final buf = StringBuffer();
      bool inQuotes = false;

      for (int i = 0; i < line.length; i++) {
        final ch = line[i];
        if (ch == '"') {
          if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
            buf.write('"');
            i++;
          } else {
            inQuotes = !inQuotes;
          }
        } else if (ch == ',' && !inQuotes) {
          res.add(buf.toString());
          buf.clear();
        } else {
          buf.write(ch);
        }
      }
      res.add(buf.toString());
      return res.map((s) => s.trim()).toList();
    }

    final header = smartSplit(lines.first);
    int idxNRP = header.indexWhere((h) => _normalize(h).contains('nrp'));
    int idxNama = header.indexWhere((h) => _normalize(h).contains('nama'));
    int idxIns = header.indexWhere((h) =>
        _normalize(h).contains('insentif') ||
        _normalize(h).contains('dibayarkan') ||
        _normalize(h).contains('nominal'));

    if (idxNRP < 0) idxNRP = 0;
    if (idxNama < 0) idxNama = 1;
    if (idxIns < 0) idxIns = 2;

    final out = <_RowDraft>[];
    for (var i = 1; i < lines.length; i++) {
      final cols = smartSplit(lines[i]);
      if (cols.length <= idxNRP) continue;

      final nrp = cols[idxNRP];
      final nama = (idxNama < cols.length) ? cols[idxNama] : '';
      final rawNominal = (idxIns < cols.length) ? cols[idxIns] : '0';

      if (nrp.isEmpty) continue;

      final nominal = _parseAnyToInt(rawNominal);
      out.add(_RowDraft(nrp: nrp, nama: nama, nominal: nominal));
    }
    return out;
  }

  String _cellString(List<Data?> row, int idx) {
    try {
      final c = row[idx];
      final v = c?.value;
      if (v == null) return '';
      return v.toString().trim();
    } catch (_) {
      return '';
    }
  }
}

// Draft row hasil parsing (dari Excel/CSV)
class _RowDraft {
  final String nrp;
  final String nama;
  final int nominal;
  _RowDraft({required this.nrp, required this.nama, required this.nominal});
}

// Row untuk preview & upsert
class _PreviewRow {
  final String nrp;
  final String nama;
  final int nominal;
  final String? usersId; // terisi jika ditemukan
  final String? alasan; // terisi untuk error/missing
  _PreviewRow({
    required this.nrp,
    required this.nama,
    required this.nominal,
    this.usersId,
    this.alasan,
  });
}
