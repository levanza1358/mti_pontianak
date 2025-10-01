import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mti_pontianak/services/supabase_service.dart';

class InsentifController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final supabaseService = SupabaseService.instance;
  late TabController tabController;

  var insentifPremiList = [].obs;
  var insentifLemburList = [].obs;
  var isLoading = false.obs;

  // Tambahkan state untuk tahun
  final selectedYear = DateTime.now().year.obs;
  final availableYears = <int>{}.obs;

  // Getter untuk data yang difilter berdasarkan tahun
  List get filteredPremiList => insentifPremiList.where((item) {
    if (item['tahun'] == null) return false;
    final tahun = DateTime.parse(item['tahun']).year;
    return tahun == selectedYear.value;
  }).toList();

  List get filteredLemburList => insentifLemburList.where((item) {
    if (item['tahun'] == null) return false;
    final tahun = DateTime.parse(item['tahun']).year;
    return tahun == selectedYear.value;
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

  Future<void> fetchInsentifPremi() async {
    isLoading(true);
    try {
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

    // Collect years from premi data
    for (final item in insentifPremiList) {
      if (item['tahun'] != null) {
        years.add(DateTime.parse(item['tahun']).year);
      }
    }

    // Collect years from lembur data
    for (final item in insentifLemburList) {
      if (item['tahun'] != null) {
        years.add(DateTime.parse(item['tahun']).year);
      }
    }

    // Add current year if no data exists
    if (years.isEmpty) {
      years.add(DateTime.now().year);
    }

    // Sort years in descending order
    availableYears.addAll(years);
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
}
