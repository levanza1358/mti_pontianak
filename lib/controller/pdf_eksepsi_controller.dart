import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../controller/eksepsi_controller.dart';

class PdfEksepsiController extends GetxController {
  final EksepsiController eksepsiController = Get.find<EksepsiController>();
  final isGenerating = false.obs;
  final pdfPath = Rxn<String>();

  Future<Uint8List> generateEksepsiPdf(Map<String, dynamic> eksepsiData) async {
    isGenerating.value = true;
    final pdf = pw.Document();
    
    try {
      // Load logo image
      final ByteData logoData = await rootBundle.load('assets/MTI_logo.png');
      final Uint8List logoBytes = logoData.buffer.asUint8List();
      final logoImage = pw.MemoryImage(logoBytes);
      
      // Format dates
      final tanggalPengajuan = eksepsiData['tanggal_pengajuan'] != null
          ? DateTime.parse(eksepsiData['tanggal_pengajuan'])
          : DateTime.now();
      
      final formattedDate = DateFormat('dd MMMM yyyy').format(tanggalPengajuan);
      
      // Get user data
      final userData = eksepsiController.currentUser.value;
      final nama = userData?['nama'] ?? 'Nama Pegawai';
      final nip = userData?['nip'] ?? 'NIP Pegawai';
      final kontak = userData?['kontak'] ?? 'Kontak Pegawai';
      final jabatan = userData?['jabatan'] ?? 'Jabatan Pegawai';
      final unitKerja = userData?['unit_kerja'] ?? 'Unit Kerja Pegawai';
      
      // Get eksepsi details
      final jenisEksepsi = eksepsiData['jenis_eksepsi'] ?? 'Jam Masuk & Pulang';
      final alasanEksepsi = eksepsiData['alasan_eksepsi'] ?? '-';
      
      // Parse tanggal list
      final tanggalList = eksepsiData['list_tanggal_eksepsi'] ?? '';
      final List<String> tanggalArray = tanggalList.split(', ');
      
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
                        pw.Text('Pontianak, $formattedDate',
                            style: pw.TextStyle(fontSize: 10)),
                        pw.SizedBox(height: 5),
                        pw.Text('Yth. REGIONAL MANAGER JAKARTA',
                            style: pw.TextStyle(fontSize: 10)),
                        pw.Text('PT PELINDO DAYA SEJAHTERA',
                            style: pw.TextStyle(fontSize: 10)),
                        pw.Text('JAKARTA',
                            style: pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                  ],
                ),
                
                pw.SizedBox(height: 20),
                
                // Subject
                pw.Text('Perihal: Permohonan Ijin Perubahan Sistem Presensi',
                    style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                
                pw.SizedBox(height: 15),
                
                pw.Text('Yang bertanda tangan dibawah ini:',
                    style: pw.TextStyle(fontSize: 11)),
                
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
                    _buildTableRow('Unit Kerja', ':', unitKerja),
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
                    1: pw.FixedColumnWidth(120),
                    2: pw.FixedColumnWidth(120),
                    3: pw.FlexColumnWidth(),
                  },
                  children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey200),
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('No', 
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('Tanggal', 
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('Jenis Eksepsi', 
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('Keterangan', 
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    ...List.generate(tanggalArray.length, (index) {
                      String tanggal = tanggalArray[index].trim();
                      if (tanggal.isEmpty) return pw.TableRow(children: [pw.SizedBox(), pw.SizedBox(), pw.SizedBox(), pw.SizedBox()]);
                      
                      DateTime? date;
                      try {
                        date = DateTime.parse(tanggal);
                        tanggal = DateFormat('dd MMMM yyyy').format(date);
                      } catch (e) {
                        // Use the raw string if parsing fails
                      }
                      
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text('${index + 1}', textAlign: pw.TextAlign.center),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(tanggal),
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
                        pw.Text('Hormat Saya,', style: pw.TextStyle(fontSize: 11)),
                        pw.SizedBox(height: 50),
                        pw.Text(nama, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    pw.SizedBox(width: 50),
                  ],
                ),
                
                pw.SizedBox(height: 30),
                
                // Approval section
                pw.Table(
                  border: pw.TableBorder.all(width: 1),
                  columnWidths: {
                    0: pw.FixedColumnWidth(200),
                    1: pw.FixedColumnWidth(200),
                    2: pw.FlexColumnWidth(),
                  },
                  children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey200),
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('SETUJU / TIDAK SETUJU MEMBERIKAN EKSEPSI PRESENSI', 
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('CATATAN PERTIMBANGAN ATASAN LANGSUNG', 
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('MENGETAHUI', 
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Container(
                          height: 100,
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.SizedBox(height: 5),
                              pw.Row(
                                children: [
                                  pw.Container(
                                    width: 10,
                                    height: 10,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                  ),
                                  pw.SizedBox(width: 5),
                                  pw.Text('Hadir / Pulang sesuai jam kerja', style: pw.TextStyle(fontSize: 8)),
                                ],
                              ),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                children: [
                                  pw.Container(
                                    width: 10,
                                    height: 10,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                  ),
                                  pw.SizedBox(width: 5),
                                  pw.Text('Terlambat / Pulang Cepat / Kurang Absen', style: pw.TextStyle(fontSize: 8)),
                                ],
                              ),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                children: [
                                  pw.Container(
                                    width: 10,
                                    height: 10,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                  ),
                                  pw.SizedBox(width: 5),
                                  pw.Text('Dengan persetujuan', style: pw.TextStyle(fontSize: 8)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        pw.Container(
                          height: 100,
                          child: pw.Center(
                            child: pw.Text('SUPERVISOR LOGISTIK', style: pw.TextStyle(fontSize: 10)),
                          ),
                        ),
                        pw.Container(
                          height: 100,
                          child: pw.Center(
                            child: pw.Text('REGIONAL MANAGER JAKARTA', style: pw.TextStyle(fontSize: 10)),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.bottomCenter,
                          child: pw.Text('', style: pw.TextStyle(fontSize: 10)),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.bottomCenter,
                          child: pw.Text('BAHTIAR SETIO HONO', style: pw.TextStyle(fontSize: 10)),
                        ),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.bottomCenter,
                          child: pw.Text('YOGI AULIA', style: pw.TextStyle(fontSize: 10)),
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
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);
      pdfPath.value = file.path;
      
      Get.snackbar(
        'Berhasil',
        'PDF berhasil disimpan di ${file.path}',
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
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Dokumen Eksepsi',
      );
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