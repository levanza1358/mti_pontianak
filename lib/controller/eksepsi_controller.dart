import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../services/supabase_service.dart';
import 'login_controller.dart';
import 'package:signature/signature.dart';

class EksepsiController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final eksepsiFormKey = GlobalKey<FormState>();
  final eksepsiEntries = <Map<String, TextEditingController>>[].obs;

  final currentUser = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;
  final isLoadingUser = false.obs;
  final isLoadingHistory = false.obs;
  final eksepsiHistory = <Map<String, dynamic>>[].obs;

  final String jenisEksepsi = 'Jam Masuk & Jam Pulang';
  final LoginController loginController = Get.find<LoginController>();

  // Signature state
  late SignatureController signatureController;
  final signatureData = Rx<Uint8List?>(null);
  final signatureUrl = RxString('');
  final hasSignature = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    addEksepsiEntry();
    _initializeUserAndHistory();

    // Init signature controller
    signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  Future<void> _initializeUserAndHistory() async {
    await loadCurrentUser();
    await loadEksepsiHistory();
  }

  Future<void> loadCurrentUser() async {
    isLoadingUser.value = true;
    try {
      final user = loginController.currentUser.value;

      if (user != null) {
        final result = await SupabaseService.instance.client
            .from('users')
            .select()
            .eq('id', user['id'])
            .single();

        currentUser.value = result;
      } else {
        currentUser.value = null;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data pengguna: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingUser.value = false;
    }
  }

  String? validateTanggalEksepsi(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal eksepsi harus diisi';
    }
    try {
      // Validasi hanya format tanggal, tanpa membatasi ke masa depan/masa lalu
      DateFormat('dd/MM/yyyy').parseStrict(value);
      return null;
    } catch (e) {
      return 'Format tanggal tidak valid (dd/MM/yyyy)';
    }
  }

  Future<void> submitEksepsiApplication() async {
    if (!eksepsiFormKey.currentState!.validate()) {
      Get.snackbar(
        'Error',
        'Mohon lengkapi form dengan benar',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validate signature presence
    if (!hasSignature.value || signatureUrl.isEmpty) {
      Get.snackbar(
        'Error',
        'Mohon buat tanda tangan terlebih dahulu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final user = currentUser.value;
      if (user == null) {
        throw Exception('User data tidak ditemukan');
      }

      final validEntries = <Map<String, dynamic>>[];
      for (int i = 0; i < eksepsiEntries.length; i++) {
        final entry = eksepsiEntries[i];
        final alasanController = entry['alasan']!;
        final tanggalController = entry['tanggal']!;

        if (alasanController.text.trim().isEmpty ||
            tanggalController.text.trim().isEmpty) {
          continue;
        }

        DateTime? parsedDate;
        try {
          parsedDate =
              DateFormat('dd/MM/yyyy').parseStrict(tanggalController.text);
        } catch (e) {
          Get.snackbar(
            'Error',
            'Format tanggal tidak valid pada eksepsi ${i + 1}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        validEntries.add({
          'alasan': alasanController.text.trim(),
          'tanggal': parsedDate,
          'urutan': i + 1,
        });
      }

      if (validEntries.isEmpty) {
        Get.snackbar(
          'Error',
          'Minimal harus ada satu tanggal eksepsi',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Tegakkan batas maksimal 10 tanggal saat pengajuan
      if (validEntries.length > 10) {
        Get.snackbar(
          'Error',
          'Maksimal 10 tanggal eksepsi per pengajuan. Hapus beberapa tanggal.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      try {
        // Pastikan URL tanda tangan tersimpan ke Storage sebelum insert
        if (signatureUrl.value.isEmpty && signatureData.value != null) {
          await uploadSignature();
        }
        // Payload utama eksepsi dengan URL tanda tangan sesuai skema baru
        final eksepsiData = {
          'user_id': user['id'],
          'jenis_eksepsi': jenisEksepsi,
          'url_ttd_eksepsi': signatureUrl.value,
        };

        final eksepsiResponse = await SupabaseService.instance.client
            .from('eksepsi')
            .insert(eksepsiData)
            .select()
            .single();

        final eksepsiId = eksepsiResponse['id'];

        final tanggalData = validEntries
            .map((entry) => {
                  'eksepsi_id': eksepsiId,
                  'tanggal_eksepsi':
                      DateFormat('yyyy-MM-dd').format(entry['tanggal']),
                  'urutan': entry['urutan'],
                  'alasan_eksepsi': entry['alasan'],
                })
            .toList();

        await SupabaseService.instance.client
            .from('eksepsi_tanggal')
            .insert(tanggalData);
      } catch (e) {
        // Jangan lakukan fallback ke tabel eksepsi dengan kolom yang tidak ada.
        // Tampilkan error agar pengguna tahu ada masalah pada pengajuan.
        Get.snackbar(
          'Error',
          'Gagal mengirim pengajuan eksepsi: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      Get.snackbar(
        'Berhasil',
        'Pengajuan eksepsi berhasil dikirim dengan ${validEntries.length} tanggal',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      clearForm();
      clearSignature();
      await loadEksepsiHistory();
      tabController.animateTo(1);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengirim pengajuan: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadEksepsiHistory() async {
    isLoadingHistory.value = true;
    try {
      final user = currentUser.value;

      if (user != null) {
        try {
          final result = await SupabaseService.instance.client
              .from('eksepsi')
              .select('''
                *,
                eksepsi_tanggal (
                  tanggal_eksepsi,
                  urutan,
                  alasan_eksepsi
                )
              ''')
              .eq('user_id', user['id'])
              .order('tanggal_pengajuan', ascending: false);

          final transformedData = result.map((item) {
            final tanggalList = (item['eksepsi_tanggal'] as List? ?? [])
                .map((t) => t['tanggal_eksepsi'] as String)
                .toList()
              ..sort();

            final firstAlasan = (item['eksepsi_tanggal'] as List? ?? [])
                    .isNotEmpty
                ? (item['eksepsi_tanggal'] as List)[0]['alasan_eksepsi'] ?? ''
                : '';

            return {
              ...item,
              'list_tanggal_eksepsi': tanggalList.join(', '),
              'jumlah_hari': tanggalList.length,
              'alasan_eksepsi': firstAlasan,
            };
          }).toList();

          eksepsiHistory.value =
              List<Map<String, dynamic>>.from(transformedData);
        } catch (e) {
          final result = await SupabaseService.instance.client
              .from('eksepsi')
              .select()
              .eq('user_id', user['id'])
              .order('tanggal_pengajuan', ascending: false);

          eksepsiHistory.value = List<Map<String, dynamic>>.from(result);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat history eksepsi: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<void> deleteEksepsi(Map<String, dynamic> eksepsiData) async {
    try {
      final eksepsiId = eksepsiData['id'];
      // Coba hapus file tanda tangan di Supabase Storage jika ada URL
      final ttdUrl = (eksepsiData['url_ttd_eksepsi'] ?? '').toString();
      if (ttdUrl.isNotEmpty) {
        try {
          // Ambil path object setelah nama bucket
          const bucketPrefix = '/ttd_eksepsi/';
          String objectPath = '';
          final idx = ttdUrl.indexOf(bucketPrefix);
          if (idx != -1) {
            objectPath = ttdUrl.substring(idx + bucketPrefix.length);
          } else {
            final uri = Uri.tryParse(ttdUrl);
            if (uri != null && uri.pathSegments.isNotEmpty) {
              // Fallback: gunakan segmen terakhir sebagai nama file
              objectPath = uri.pathSegments.last;
            }
          }

          if (objectPath.isNotEmpty) {
            await SupabaseService.instance.client.storage
                .from('ttd_eksepsi')
                .remove([objectPath]);
          }
        } catch (e) {
          // Jangan blokir penghapusan eksepsi jika hapus TTD gagal
          Get.snackbar(
            'Peringatan',
            'Gagal menghapus TTD dari storage: $e',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
      }

      await SupabaseService.instance.client
          .from('eksepsi')
          .delete()
          .eq('id', eksepsiId);

      await loadEksepsiHistory();
      // Pastikan tidak ada overlay yang masih terbuka sebelum menampilkan snackbar
      try {
        if (Get.isDialogOpen == true) {
          Get.back();
        }
        if (Get.isSnackbarOpen == true) {
          Get.closeAllSnackbars();
        }
      } catch (_) {
        // abaikan jika properti tidak tersedia pada versi GetX
      }

      Get.snackbar(
        'Berhasil',
        'Eksepsi berhasil dihapus',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      // Tutup overlay yang mungkin mengganggu sebelum menampilkan snackbar error
      try {
        if (Get.isDialogOpen == true) {
          Get.back();
        }
        if (Get.isSnackbarOpen == true) {
          Get.closeAllSnackbars();
        }
      } catch (_) {}
      Get.snackbar(
        'Error',
        'Gagal menghapus eksepsi: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> showDeleteConfirmation(Map<String, dynamic> eksepsiData) async {
    final dateString = eksepsiData['list_tanggal_eksepsi'] ?? '';
    final dates = dateString.isNotEmpty
        ? dateString.split(',').map((e) => e.trim()).toList()
        : <String>[];
    // Tutup snackbar aktif sebelum membuka dialog untuk menghindari konflik overlay
    try {
      if (Get.isSnackbarOpen == true) {
        Get.closeAllSnackbars();
      }
    } catch (_) {
      // abaikan jika properti tidak tersedia pada versi GetX
    }
    // Beri jeda singkat agar overlay benar-benar tertutup
    await Future.delayed(const Duration(milliseconds: 50));

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Apakah Anda yakin ingin menghapus eksepsi ini?'),
            const SizedBox(height: 8),
            Text(
              '• Tanggal: ${dates.isNotEmpty ? "${dates.first} - ${dates.last}" : "-"}',
            ),
            Text('• Jenis: ${eksepsiData['jenis_eksepsi'] ?? "-"}'),
            Text('• Alasan: ${eksepsiData['alasan_eksepsi'] ?? "-"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (confirmed == true) {
      // Beri jeda singkat untuk memastikan dialog benar-benar tertutup
      await Future.delayed(const Duration(milliseconds: 50));
      await deleteEksepsi(eksepsiData);
    }
  }

  Future<void> refreshData() async {
    await loadCurrentUser();
    await loadEksepsiHistory();
  }

  void addEksepsiEntry() {
    // Batasi maksimal 10 entri tanggal eksepsi
    if (eksepsiEntries.length >= 10) {
      Get.snackbar(
        'Batas tercapai',
        'Maksimal 10 tanggal eksepsi per pengajuan.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    eksepsiEntries.add({
      'alasan': TextEditingController(),
      'tanggal': TextEditingController(),
    });
  }

  void removeEksepsiEntry(int index) {
    if (eksepsiEntries.length > 1) {
      final alasan = eksepsiEntries[index]['alasan'];
      final tanggal = eksepsiEntries[index]['tanggal'];
      // Lepas dulu dari UI, baru dispose setelah frame berikutnya
      eksepsiEntries.removeAt(index);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        alasan?.dispose();
        tanggal?.dispose();
      });
    }
  }

  void setSelectedDate(DateTime date, int index) {
    if (index < eksepsiEntries.length) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(date);
      eksepsiEntries[index]['tanggal']?.text = formattedDate;
    }
  }

  void clearForm() {
    // Buang entri tambahan dengan aman (detach dari UI dulu)
    if (eksepsiEntries.length > 1) {
      final toDispose = eksepsiEntries
          .sublist(1)
          .map((e) => [e['alasan'], e['tanggal']])
          .toList();
      eksepsiEntries.removeRange(1, eksepsiEntries.length);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (final pair in toDispose) {
          pair[0]?.dispose();
          pair[1]?.dispose();
        }
      });
    }
    if (eksepsiEntries.isNotEmpty) {
      eksepsiEntries[0]['alasan']?.clear();
      eksepsiEntries[0]['tanggal']?.clear();
    }
    eksepsiFormKey.currentState?.reset();
  }

  @override
  void onClose() {
    for (final entry in eksepsiEntries) {
      entry['alasan']?.dispose();
      entry['tanggal']?.dispose();
    }
    signatureController.dispose();
    tabController.dispose();
    super.onClose();
  }

  String? validateAlasan(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Alasan eksepsi harus diisi';
    }
    return null;
  }

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'disetujui':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      case 'menunggu':
      default:
        return Colors.orange;
    }
  }

  IconData getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'disetujui':
        return Icons.check_circle;
      case 'ditolak':
        return Icons.cancel;
      case 'menunggu':
      default:
        return Icons.access_time;
    }
  }

  // Signature helpers
  void clearSignature() {
    signatureController.clear();
    signatureData.value = null;
    hasSignature.value = false;
    signatureUrl.value = '';
  }

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

  Future<void> uploadSignature() async {
    if (signatureData.value == null) return;

    try {
      isLoading.value = true;
      final fileName = 'signature_${DateTime.now().millisecondsSinceEpoch}.png';
      final bytes = signatureData.value!;

      final response = await SupabaseService.instance.client.storage
          .from('ttd_eksepsi')
          .uploadBinary(fileName, bytes);

      if (response.isNotEmpty) {
        final String publicUrl = SupabaseService.instance.client.storage
            .from('ttd_eksepsi')
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
}
