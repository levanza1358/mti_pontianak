import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mti_pontianak/services/supabase_service.dart';
import 'package:mti_pontianak/controller/login_controller.dart';

class InsentifController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final supabaseService = SupabaseService.instance;
  late TabController tabController;

  var insentifPremiList = [].obs;
  var insentifLemburList = [].obs;
  var isLoading = false.obs;

  // Login controller untuk mengetahui user saat ini & permission
  final loginController = Get.find<LoginController>();

  // Tambahkan state untuk tahun
  final selectedYear = DateTime.now().year.obs;
  final availableYears = <int>{}.obs;

  // Getter untuk data yang difilter berdasarkan tahun
  List get filteredPremiList => insentifPremiList.where((item) {
        final tahun = _resolveYear(item);
        return tahun != null && tahun == selectedYear.value;
      }).toList();

  List get filteredLemburList => insentifLemburList.where((item) {
        final tahun = _resolveYear(item);
        return tahun != null && tahun == selectedYear.value;
      }).toList();

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

  Future<void> fetchInsentifLembur() async {
    isLoading(true);
    try {
      final currentUser = loginController.currentUser.value;
      if (currentUser == null) {
        insentifLemburList.value = [];
        Get.snackbar(
          'Error',
          'User tidak ditemukan. Silakan login ulang.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      final userId = currentUser['id'] as String?;
      final data = await supabaseService.getInsentifLembur(userId: userId);
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

  Future<void> fetchInsentifPremi() async {
    isLoading(true);
    try {
      final currentUser = loginController.currentUser.value;
      if (currentUser == null) {
        insentifPremiList.value = [];
        Get.snackbar(
          'Error',
          'User tidak ditemukan. Silakan login ulang.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      final userId = currentUser['id'] as String?;
      final data = await supabaseService.getInsentifPremi(userId: userId);
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

  String formatCurrency(dynamic nominal) {
    final value = _safeInt(nominal);
    return 'Rp ${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void updateAvailableYears() {
    final years = <int>{};

    // Collect years from premi data
    for (final item in insentifPremiList) {
      final y = _resolveYear(item);
      if (y != null) years.add(y);
    }

    // Collect years from lembur data
    for (final item in insentifLemburList) {
      final y = _resolveYear(item);
      if (y != null) years.add(y);
    }

    // Add current year if no data exists
    if (years.isEmpty) {
      years.add(DateTime.now().year);
    }

    // Update available years set
    availableYears
      ..clear()
      ..addAll(years);
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

      // Ambil data
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

  // Helper untuk mendapatkan tahun secara aman dari item data
  int? _resolveYear(dynamic item) {
    try {
      final dynamic tahunRaw = item['tahun'];
      final dynamic bulanRaw = item['bulan'];

      // Prioritaskan field 'tahun' jika valid
      final tahun = _extractYearFromSafe(tahunRaw);
      if (tahun != null) return tahun;

      // Fallback ke field 'bulan' jika tersedia (tanggal lengkap)
      final tahunDariBulan = _extractYearFromSafe(bulanRaw);
      if (tahunDariBulan != null) return tahunDariBulan;
    } catch (_) {}
    return null;
  }

  // Versi aman untuk ekstraksi tahun tanpa karakter tak terlihat pada pola RegExp
  int? _extractYearFromSafe(dynamic value) {
    if (value == null) return null;
    if (value is int) {
      if (value >= 1900 && value <= 2100) return value;
      return null;
    }
    if (value is String) {
      final s = value.trim();
      // Jika panjang 4 dan semua digit, anggap sebagai tahun
      if (s.length == 4 && int.tryParse(s) != null) {
        final y = int.parse(s);
        if (y >= 1900 && y <= 2100) return y;
      }
      // Coba parse sebagai tanggal penuh
      final dt = DateTime.tryParse(s);
      if (dt != null) return dt.year;
    }
    return null;
  }

  int _safeInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}
