import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../controller/eksepsi_controller.dart';
import '../services/supabase_service.dart';

class PdfEksepsiController extends GetxController {
  final EksepsiController eksepsiController = Get.find<EksepsiController>();
  final SupabaseService supabaseService = SupabaseService.instance;
  final isGenerating = false.obs;
  final pdfPath = Rxn<String>();

  // Method untuk generate nama file PDF dengan format yang benar
  String generatePdfFileName(Map<String, dynamic> userData) {
    final nrp = userData['nrp'] ?? '00000';
    final randomNumber =
        (10000 + (DateTime.now().millisecondsSinceEpoch % 90000)).toString();
    return 'surat_eksepsi_${nrp}_$randomNumber.pdf';
  }

  Future<Map<String, dynamic>?> fetchSupervisorByJenis(String jenis) async {
    try {
      final response = await supabaseService.client
          .from('supervisor')
          .select('*')
          .eq('jenis', jenis)
          .single();

      return response;
    } catch (e) {
      return null;
    }
  }

  // Method untuk menentukan jenis supervisor berdasarkan status user
  String getSupervisorJenisByUserStatus(String? userStatus) {
    if (userStatus == 'Non Operasional') {
      return 'Penunjang';
    } else if (userStatus == 'Operasional') {
      return 'Logistik';
    }
    // Default ke Logistik jika status tidak dikenali
    return 'Logistik';
  }

  Future<Uint8List> generateEksepsiPdf(Map<String, dynamic> eksepsiData) async {
    isGenerating.value = true;
    final pdf = pw.Document();

    try {
      // Initialize Indonesian locale for date formatting
      await initializeDateFormatting('id_ID', null);

      // Load logo image
      final ByteData logoData = await rootBundle.load('assets/MTI_logo.png');
      final Uint8List logoBytes = logoData.buffer.asUint8List();
      final logoImage = pw.MemoryImage(logoBytes);

      // Format dates
      final tanggalPengajuan = eksepsiData['tanggal_pengajuan'] != null
          ? DateTime.parse(eksepsiData['tanggal_pengajuan'])
          : DateTime.now();

      final formattedDate = DateFormat(
        'dd MMMM yyyy',
        'id_ID',
      ).format(tanggalPengajuan);

      // Get user data
      final userData = eksepsiController.currentUser.value;
      final nama = userData?['name'] ?? 'Nama Pegawai';
      final nip = userData?['nrp'] ?? 'NRP Pegawai';
      final kontak = userData?['kontak'] ?? '-';
      final jabatan = userData?['jabatan'] ?? 'Jabatan Pegawai';
      final userStatus = userData?['status'] ?? 'Operasional';

      // Fetch supervisor data berdasarkan status user
      final supervisorJenis = getSupervisorJenisByUserStatus(userStatus);
      final supervisorData = await fetchSupervisorByJenis(supervisorJenis);
      final managerData = await fetchSupervisorByJenis('Manager_PDS');

      // Set supervisor info
      final supervisorNama =
          supervisorData?['nama'] ??
          'SUPERVISOR ${supervisorJenis.toUpperCase()}';
      final supervisorJabatan =
          supervisorData?['jabatan'] ??
          'SUPERVISOR ${supervisorJenis.toUpperCase()}';
      final managerNama = managerData?['nama'] ?? 'REGIONAL MANAGER';
      final managerJabatan =
          managerData?['jabatan'] ?? 'REGIONAL MANAGER JAKARTA';

      // Get eksepsi details
      final jenisEksepsi = eksepsiData['jenis_eksepsi'] ?? 'Jam Masuk & Pulang';

      // Prepare signature image (prefer URL stored on record, fallback to current controller state)
      pw.ImageProvider? ttdImageProvider;
      final String recordTtdUrl = (eksepsiData['url_ttd_eksepsi'] ?? '').toString();
      final String controllerTtdUrl = eksepsiController.signatureUrl.value;
      final String ttdUrl = recordTtdUrl.isNotEmpty ? recordTtdUrl : controllerTtdUrl;
      final Uint8List? ttdBytes = eksepsiController.signatureData.value;
      if (ttdUrl.isNotEmpty) {
        try {
          ttdImageProvider = await networkImage(ttdUrl);
        } catch (_) {
          ttdImageProvider = null;
        }
      }
      if (ttdImageProvider == null && ttdBytes != null) {
        try {
          ttdImageProvider = pw.MemoryImage(ttdBytes);
        } catch (_) {
          ttdImageProvider = null;
        }
      }

      // Get tanggal data with alasan per tanggal
      final eksepsiTanggalList = eksepsiData['eksepsi_tanggal'] as List? ?? [];

      // Sort by urutan or tanggal_eksepsi
      eksepsiTanggalList.sort((a, b) {
        final urutanA = a['urutan'] ?? 0;
        final urutanB = b['urutan'] ?? 0;
        return urutanA.compareTo(urutanB);
      });

      // Create PDF content
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header with logo
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Image(logoImage, width: 120),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Pontianak, $formattedDate',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Yth. REGIONAL MANAGER JAKARTA',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text(
                          'PT PELINDO DAYA SEJAHTERA',
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text('JAKARTA', style: pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                  ],
                ),

                pw.SizedBox(height: 20),

                // Subject
                pw.Text(
                  'Perihal: Permohonan Ijin Perubahan Sistem Presensi',
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 15),

                pw.Text(
                  'Yang bertanda tangan dibawah ini:',
                  style: pw.TextStyle(fontSize: 11),
                ),

                pw.SizedBox(height: 10),

                // User details
                pw.Table(
                  columnWidths: {
                    0: pw.FixedColumnWidth(100),
                    1: pw.FixedColumnWidth(10),
                    2: pw.FlexColumnWidth(),
                  },
                  children: [
                    _buildTableRow('Nama', ':', nama),
                    _buildTableRow('NIP', ':', nip),
                    _buildTableRow('Kontak HP / WA', ':', kontak),
                    _buildTableRow('Jabatan', ':', jabatan),
                  ],
                ),

                pw.SizedBox(height: 15),

                pw.Text(
                  'Dengan ini mengajukan permohonan perubahan eksepsi presensi dengan rincian sebagai berikut:',
                  style: pw.TextStyle(fontSize: 11),
                ),

                pw.SizedBox(height: 10),

                // Eksepsi details table
                pw.Table(
                  border: pw.TableBorder.all(width: 1),
                  columnWidths: {
                    0: pw.FixedColumnWidth(30),
                    1: pw.FixedColumnWidth(100),
                    2: pw.FixedColumnWidth(180),
                    3: pw.FlexColumnWidth(),
                  },
                  children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey200),
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'No',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Tanggal',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Jenis Eksepsi',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Keterangan',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    ...List.generate(eksepsiTanggalList.length, (index) {
                      final tanggalData = eksepsiTanggalList[index];
                      final tanggalEksepsi =
                          tanggalData['tanggal_eksepsi'] ?? '';
                      final alasanEksepsi =
                          tanggalData['alasan_eksepsi'] ?? '-';

                      if (tanggalEksepsi.isEmpty) {
                        return pw.TableRow(
                          children: [
                            pw.SizedBox(),
                            pw.SizedBox(),
                            pw.SizedBox(),
                            pw.SizedBox(),
                          ],
                        );
                      }

                      String formattedTanggal = tanggalEksepsi;
                      try {
                        final date = DateTime.parse(tanggalEksepsi);
                        formattedTanggal = DateFormat(
                          'dd MMMM yyyy',
                          'id_ID',
                        ).format(date);
                      } catch (e) {
                        // Use the raw string if parsing fails
                      }

                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              '${index + 1}',
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(formattedTanggal),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(jenisEksepsi),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(alasanEksepsi),
                          ),
                        ],
                      );
                    }),
                  ],
                ),

                pw.SizedBox(height: 15),

                pw.Text(
                  'Demikian surat permohonan ini saya buat untuk dapat dipertimbangkan sebagaimana mestinya.',
                  style: pw.TextStyle(fontSize: 11),
                ),

                pw.SizedBox(height: 30),

                // Signature
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          'Hormat Saya,',
                          style: pw.TextStyle(fontSize: 11),
                        ),
                        if (ttdImageProvider != null)
                          pw.Container(
                            height: 60,
                            padding: const pw.EdgeInsets.symmetric(vertical: 4),
                            child: pw.Image(ttdImageProvider!, fit: pw.BoxFit.contain),
                          )
                        else
                          pw.SizedBox(height: 50),
                        pw.Column(
                          children: [
                            pw.Text(
                              nama.toUpperCase(),
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Container(
                              width: nama.length * 6.0,
                              height: 1,
                              color: PdfColors.black,
                              margin: pw.EdgeInsets.only(top: 2),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(width: 50),
                  ],
                ),

                pw.SizedBox(height: 30),

                // Signature table
                pw.Table(
                  border: pw.TableBorder.all(width: 1),
                  columnWidths: {
                    0: pw.FlexColumnWidth(1),
                    1: pw.FlexColumnWidth(1),
                    2: pw.FlexColumnWidth(1),
                  },
                  children: [
                    // Header row
                    pw.TableRow(
                      children: [
                        pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'SETUJU / TIDAK SETUJU MEMBERIKAN EKSEPSI PRESENSI',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'CATATAN PERTIMBANGAN ATASAN LANGSUNG',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'MENGETAHUI',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    // Content row
                    pw.TableRow(
                      children: [
                        pw.Container(
                          height: 60,
                          padding: pw.EdgeInsets.all(6),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            children: [
                              pw.Row(
                                children: [
                                  pw.Container(
                                    width: 10,
                                    height: 10,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(width: 1),
                                    ),
                                  ),
                                  pw.SizedBox(width: 5),
                                  pw.Text(
                                    'Hadir / Pulang sesuai jam kerja',
                                    style: pw.TextStyle(fontSize: 7),
                                  ),
                                ],
                              ),
                              pw.Row(
                                children: [
                                  pw.Container(
                                    width: 10,
                                    height: 10,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(width: 1),
                                    ),
                                  ),
                                  pw.SizedBox(width: 5),
                                  pw.Expanded(
                                    child: pw.Text(
                                      'Terlambat / Pulang Cepat / Kurang Absen dengan persetujuan',
                                      style: pw.TextStyle(fontSize: 7),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        pw.Container(
                          height: 60,
                          padding: pw.EdgeInsets.all(6),
                          child: pw.Column(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                supervisorJabatan.toUpperCase(),
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                              pw.SizedBox(height: 15),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    supervisorNama.toUpperCase(),
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                  pw.Container(
                                    width: supervisorNama.length * 4.5,
                                    height: 1,
                                    color: PdfColors.black,
                                    margin: pw.EdgeInsets.only(top: 1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        pw.Container(
                          height: 60,
                          padding: pw.EdgeInsets.all(6),
                          child: pw.Column(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                managerJabatan.toUpperCase(),
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                              pw.SizedBox(height: 15),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    managerNama.toUpperCase(),
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                  pw.Container(
                                    width: managerNama.length * 4.5,
                                    height: 1,
                                    color: PdfColors.black,
                                    margin: pw.EdgeInsets.only(top: 1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      return pdf.save();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal membuat PDF: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return Uint8List(0);
    } finally {
      isGenerating.value = false;
    }
  }

  pw.TableRow _buildTableRow(String label, String separator, String value) {
    return pw.TableRow(
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 11)),
        pw.Text(separator, style: pw.TextStyle(fontSize: 11)),
        pw.Text(value, style: pw.TextStyle(fontSize: 11)),
      ],
    );
  }

  Future<void> savePdfToDevice(Uint8List pdfBytes, String fileName) async {
    try {
      // Di web, path_provider tidak didukung. Gunakan Printing.sharePdf
      if (kIsWeb) {
        await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
        Get.snackbar(
          'Berhasil',
          'PDF diunduh melalui browser',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);
      pdfPath.value = file.path;

      Get.snackbar(
        'Berhasil',
        'PDF tersimpan di ${file.path}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan PDF: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> sharePdf(Uint8List pdfBytes, String fileName) async {
    try {
      // Di web, langsung trigger download/share via Printing
      if (kIsWeb) {
        await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
        return;
      }

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);

      await Share.shareXFiles([XFile(file.path)], text: 'Dokumen Eksepsi');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal membagikan PDF: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> printPdf(Uint8List pdfBytes) async {
    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mencetak PDF: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
