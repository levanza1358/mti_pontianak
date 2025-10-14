import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:mti_pontianak/services/supabase_service.dart';

class SemuaInsentifController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final supabaseService = SupabaseService.instance;
  late TabController tabController;

  var insentifPremiList = [].obs;
  var insentifLemburList = [].obs;
  var isLoading = false.obs;

  // State untuk tahun
  final selectedYear = DateTime.now().year.obs;
  final availableYears = <int>{}.obs;

  // Getter untuk data yang difilter berdasarkan tahun
  List get filteredPremiList {
    final list = insentifPremiList.where((item) {
      final tahunStr = item['tahun']?.toString();
      final tahun = tahunStr != null ? DateTime.tryParse(tahunStr)?.year : null;
      return tahun == selectedYear.value;
    }).toList();

    list.sort((a, b) {
      final sa = a['bulan']?.toString();
      final sb = b['bulan']?.toString();
      final da = sa != null ? DateTime.tryParse(sa) : null;
      final db = sb != null ? DateTime.tryParse(sb) : null;
      if (da == null && db == null) return 0;
      if (da == null) return 1; // yang tidak punya bulan di bawah
      if (db == null) return -1;
      return db.compareTo(da); // terbaru di atas (descending)
    });

    return list;
  }

  List get filteredLemburList {
    final list = insentifLemburList.where((item) {
      final tahunStr = item['tahun']?.toString();
      final tahun = tahunStr != null ? DateTime.tryParse(tahunStr)?.year : null;
      return tahun == selectedYear.value;
    }).toList();

    list.sort((a, b) {
      final sa = a['bulan']?.toString();
      final sb = b['bulan']?.toString();
      final da = sa != null ? DateTime.tryParse(sa) : null;
      final db = sb != null ? DateTime.tryParse(sb) : null;
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return db.compareTo(da);
    });

    return list;
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

  Future<void> fetchInsentifPremi() async {
    isLoading(true);
    try {
      // Tanpa filter users_id
      final data = await supabaseService.getInsentifPremi();
      insentifPremiList.value = data;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil data Insentif Premi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchInsentifLembur() async {
    isLoading(true);
    try {
      // Tanpa filter users_id
      final data = await supabaseService.getInsentifLembur();
      insentifLemburList.value = data;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil data Insentif Lembur',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  String formatCurrency(int? nominal) {
    if (nominal == null) return 'Rp 0';
    return 'Rp ${nominal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void updateAvailableYears() {
    final years = <int>{};

    // Kumpulkan tahun dari data premi
    for (final item in insentifPremiList) {
      final tahunStr = item['tahun']?.toString();
      if (tahunStr != null) {
        final parsed = DateTime.tryParse(tahunStr);
        if (parsed != null) {
          years.add(parsed.year);
        }
      }
    }

    // Kumpulkan tahun dari data lembur
    for (final item in insentifLemburList) {
      final tahunStr = item['tahun']?.toString();
      if (tahunStr != null) {
        final parsed = DateTime.tryParse(tahunStr);
        if (parsed != null) {
          years.add(parsed.year);
        }
      }
    }

    // Jika tidak ada data sama sekali, masukkan tahun berjalan
    if (years.isEmpty) {
      years.add(DateTime.now().year);
    }

    // Perbarui daftar tahun tersedia (replace seluruh set agar reaktif)
    availableYears.assignAll(years);

    // Pastikan selectedYear valid: jika tidak ada di daftar, pilih tahun terbaru
    if (!availableYears.contains(selectedYear.value)) {
      final sorted = years.toList()..sort((a, b) => b.compareTo(a));
      selectedYear.value = sorted.isNotEmpty ? sorted.first : DateTime.now().year;
    }
  }

  void changeYear(int year) {
    selectedYear.value = year;
    update();
  }

  Future<void> _initializeData() async {
    try {
      // Test koneksi terlebih dahulu
      final isConnected = await supabaseService.testConnection();

      if (!isConnected) {
        Get.snackbar(
          'Error',
          'Tidak dapat terhubung ke server',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Ambil data tanpa filter
      await fetchInsentifPremi();
      await fetchInsentifLembur();

      // Update daftar tahun yang tersedia
      updateAvailableYears();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteInsentifItem({
    required Map<String, dynamic> item,
    required String jenis, // 'Premi' atau 'Lembur'
  }) async {
    try {
      final table = jenis.toLowerCase() == 'premi' ? 'insentif_premi' : 'insentif_lembur';

      final id = item['id'];
      if (id == null) {
        Get.snackbar(
          'Gagal',
          'ID data tidak ditemukan, tidak dapat menghapus',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      await supabaseService.client.from(table).delete().eq('id', id);

      // Refresh data dan statistik tahun
      await fetchInsentifPremi();
      await fetchInsentifLembur();
      updateAvailableYears();

      Get.snackbar(
        'Berhasil',
        'Data insentif berhasil dihapus',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

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
        Get.snackbar(
          'Gagal',
          'Tidak dapat membaca isi file',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Parse baris excel
      final List<Map<String, dynamic>> insertRows = [];

      final ext = (file.extension ?? '').toLowerCase();
      if (ext == 'xlsx' || ext == 'xls') {
        final excel = Excel.decodeBytes(bytes);
        if (excel.tables.isEmpty) {
          Get.snackbar(
            'Gagal',
            'Sheet pada file Excel kosong',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
        final sheet = excel.tables[excel.tables.keys.first]!;
        if (sheet.rows.isEmpty) {
          Get.snackbar(
            'Gagal',
            'Tidak ada data pada sheet pertama',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        // Header detection
        final header = sheet.rows.first
            .map((c) => (c?.value?.toString() ?? '').trim())
            .toList();
        int idxNRP = header.indexWhere((h) => _normalize(h).contains('nrp'));
        int idxNama = header.indexWhere((h) => _normalize(h).contains('nama'));
        int idxIns = header.indexWhere((h) =>
            _normalize(h).contains('insentif') ||
            _normalize(h).contains('dibayarkan'));

        // Jika tidak ada header, fallback ke asumsi kolom 0,1,2
        if (idxNRP < 0) idxNRP = 0;
        if (idxNama < 0) idxNama = 1;
        if (idxIns < 0) idxIns = 2;

        for (var r = 1; r < sheet.rows.length; r++) {
          final row = sheet.rows[r];
          String nrp = _cellString(row, idxNRP);
          String nama = _cellString(row, idxNama);
          String rawNominal = _cellString(row, idxIns);
          if (nrp.isEmpty) continue;
          final nominal = _parseRupiahToInt(rawNominal);

          final user = await supabaseService.getUserByNRP(nrp);
          final usersId = user != null ? user['id'] : null;
          if (usersId == null) {
            // Skip jika user tidak ditemukan; bisa ditingkatkan jadi log
            continue;
          }

          final data = {
            'users_id': usersId,
            'nrp': nrp,
            'nama': (user?['name'] ?? nama),
            'nominal': nominal,
            'bulan': DateTime(tahun, bulan, 1).toIso8601String(),
            'tahun': DateTime(tahun, 1, 1).toIso8601String(),
          };
          insertRows.add(data);
        }
      } else if (ext == 'csv') {
        final content = String.fromCharCodes(bytes);
        final lines = content
            .split(RegExp(r'\r?\n'))
            .where((l) => l.trim().isNotEmpty)
            .toList();
        if (lines.isEmpty) {
          Get.snackbar('Gagal', 'File CSV kosong',
              backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }
        final header = lines.first.split(',').map((s) => s.trim()).toList();
        int idxNRP = header.indexWhere((h) => _normalize(h).contains('nrp'));
        int idxNama = header.indexWhere((h) => _normalize(h).contains('nama'));
        int idxIns = header.indexWhere((h) =>
            _normalize(h).contains('insentif') ||
            _normalize(h).contains('dibayarkan'));
        if (idxNRP < 0) idxNRP = 0;
        if (idxNama < 0) idxNama = 1;
        if (idxIns < 0) idxIns = 2;

        for (var i = 1; i < lines.length; i++) {
          final cols = lines[i].split(',');
          if (cols.length <= idxNRP) continue;
          final nrp = cols[idxNRP].trim();
          final nama = idxNama < cols.length ? cols[idxNama].trim() : '';
          final rawNominal = idxIns < cols.length ? cols[idxIns].trim() : '0';
          if (nrp.isEmpty) continue;
          final nominal = _parseRupiahToInt(rawNominal);
          final user = await supabaseService.getUserByNRP(nrp);
          final usersId = user != null ? user['id'] : null;
          if (usersId == null) continue;
          insertRows.add({
            'users_id': usersId,
            'nrp': nrp,
            'nama': (user?['name'] ?? nama),
            'nominal': nominal,
            'bulan': DateTime(tahun, bulan, 1).toIso8601String(),
            'tahun': DateTime(tahun, 1, 1).toIso8601String(),
          });
        }
      }

      if (insertRows.isEmpty) {
        Get.snackbar(
          'Tidak ada data',
          'Baris valid untuk diimpor tidak ditemukan',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final table =
          jenis.toLowerCase() == 'premi' ? 'insentif_premi' : 'insentif_lembur';
      await supabaseService.client.from(table).insert(insertRows);

      await fetchInsentifPremi();
      await fetchInsentifLembur();
      updateAvailableYears();

      Get.snackbar(
        'Berhasil',
        'Impor ${insertRows.length} baris ke $jenis',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal impor: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _normalize(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
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

  int _parseRupiahToInt(String input) {
    // Normalisasi string rupiah agar aman untuk di-parse.
    // Tangani variasi: "Rp 2,125,816", "1.234.567,89", "629709.302325581".
    var s = input.trim();
    if (s.isEmpty) return 0;

    // Hilangkan penanda mata uang (case-insensitive) dan spasi
    s = s.replaceAll(RegExp(r'rp|idr', caseSensitive: false), '');
    s = s.replaceAll(' ', '');

    final hasComma = s.contains(',');
    final hasDot = s.contains('.');
    String integerPart = s;

    if (hasComma && hasDot) {
      // Jika terdapat koma dan titik, tentukan desimal berdasarkan separator terakhir.
      // - Jika yang terakhir muncul adalah koma, anggap koma sebagai desimal (format Indonesia)
      // - Jika yang terakhir muncul adalah titik, anggap titik sebagai desimal (format US)
      final lastComma = s.lastIndexOf(',');
      final lastDot = s.lastIndexOf('.');
      final decimalIsComma = lastComma > lastDot;
      if (decimalIsComma) {
        integerPart = s.substring(0, lastComma).replaceAll('.', '');
      } else {
        integerPart = s.substring(0, lastDot).replaceAll(',', '');
      }
    } else if (hasComma && !hasDot) {
      // Hanya koma: anggap koma sebagai pemisah ribuan
      integerPart = s.replaceAll(',', '');
    } else if (!hasComma && hasDot) {
      // Hanya titik: bisa berarti ribuan (banyak titik) atau desimal (satu titik)
      final dotCount = RegExp(r'\.').allMatches(s).length;
      if (dotCount == 1) {
        // Satu titik, anggap sebagai desimal. Ambil bagian sebelum titik.
        integerPart = s.split('.').first;
      } else {
        // Banyak titik: anggap sebagai ribuan, hapus semuanya
        integerPart = s.replaceAll('.', '');
      }
    } else {
      // Hanya digit
      integerPart = s;
    }

    // Sisakan hanya digit
    integerPart = integerPart.replaceAll(RegExp(r'[^0-9]'), '');
    if (integerPart.isEmpty) return 0;

    final parsed = int.tryParse(integerPart) ?? 0;
    const maxInt32 = 2147483647; // cegah overflow ke kolom integer
    return parsed > maxInt32 ? maxInt32 : parsed;
  }
}
