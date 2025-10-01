import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';
import '../services/supabase_service.dart';

class SuratKeluarController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  // Signature controller
  late SignatureController signatureController;

  // Form controllers
  final namaPerusahaanController = TextEditingController();
  final judulSuratController = TextEditingController();
  final deskripsiSuratController = TextEditingController();
  final nomorSuratController = TextEditingController();
  final tanggalKirimController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final suratKeluarList = <Map<String, dynamic>>[].obs;
  final selectedDate = Rx<DateTime?>(null);
  final signatureData = Rx<Uint8List?>(null);
  final signatureUrl = RxString('');
  final hasSignature = false.obs;
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    signatureController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
    loadSuratKeluarList();
  }

  @override
  void onClose() {
    namaPerusahaanController.dispose();
    judulSuratController.dispose();
    deskripsiSuratController.dispose();
    nomorSuratController.dispose();
    tanggalKirimController.dispose();
    signatureController.dispose();
    tabController.dispose();
    super.onClose();
  }

  // Clear signature
  void clearSignature() {
    signatureController.clear();
    signatureData.value = null;
    hasSignature.value = false;
    signatureUrl.value = '';
  }

  // Save signature
  Future<void> saveSignature() async {
    if (signatureController.isEmpty) {
      Get.snackbar(
        'Error',
        'Tanda tangan masih kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final signature = await signatureController.toPngBytes();
      if (signature != null) {
        signatureData.value = signature;
        hasSignature.value = true;
        await uploadSignature();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan tanda tangan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Upload signature to Supabase Storage
  Future<void> uploadSignature() async {
    if (signatureData.value == null) return;

    try {
      isLoading.value = true;
      final fileName = 'signature_${DateTime.now().millisecondsSinceEpoch}.png';
      final bytes = signatureData.value!;

      final response = await SupabaseService.instance.client.storage
          .from('ttd_surat_keluar')
          .uploadBinary(fileName, bytes);

      if (response.isNotEmpty) {
        final String publicUrl = SupabaseService.instance.client.storage
            .from('ttd_surat_keluar')
            .getPublicUrl(fileName);

        signatureUrl.value = publicUrl;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal upload tanda tangan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Show signature dialog
  void showSignatureDialog() {
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          width: double.maxFinite,
          height: Get.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tanda Tangan Digital',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Silakan buat tanda tangan Anda di area di bawah ini:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Signature(
                    controller: signatureController,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        clearSignature();
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text('Hapus'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (signatureController.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Mohon buat tanda tangan terlebih dahulu',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }
                        saveSignature();
                        Get.back();
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Simpan'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Load surat keluar list
  Future<void> loadSuratKeluarList() async {
    try {
      isLoading.value = true;
      final response = await SupabaseService.instance.client
          .from('surat_keluar')
          .select()
          .order('created_at', ascending: false);

      suratKeluarList.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load surat keluar list: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Submit form
  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;
    if (!hasSignature.value || signatureUrl.isEmpty) {
      Get.snackbar(
        'Error',
        'Mohon buat tanda tangan terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      await SupabaseService.instance.client.from('surat_keluar').insert({
        'nama_perusahaan': namaPerusahaanController.text,
        'judul_surat': judulSuratController.text,
        'deskripsi_surat': deskripsiSuratController.text,
        'nomor_surat': nomorSuratController.text.isEmpty
            ? null
            : nomorSuratController.text,
        'url_ttd': signatureUrl.value,
      });

      clearForm();
      await loadSuratKeluarList();
      Get.snackbar(
        'Success',
        'Surat keluar berhasil disimpan',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Switch to history tab to show the saved data
      tabController.animateTo(1);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan surat keluar: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear form
  void clearForm() {
    namaPerusahaanController.clear();
    judulSuratController.clear();
    deskripsiSuratController.clear();
    nomorSuratController.clear();
    tanggalKirimController.clear();
    selectedDate.value = null;
    signatureData.value = null;
    signatureUrl.value = '';
    hasSignature.value = false;
    signatureController.clear();
  }

  // Form validators
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }
}
