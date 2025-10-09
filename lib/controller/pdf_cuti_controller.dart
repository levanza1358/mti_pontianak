import 'dart:io';
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
import '../controller/cuti_controller.dart';
import '../services/supabase_service.dart';

class PdfCutiController extends GetxController {
  final CutiController cutiController = Get.find<CutiController>();
  final SupabaseService supabaseService = SupabaseService.instance;
  final isGenerating = false.obs;
  final pdfPath = Rxn<String>();

  // Method untuk generate nama file PDF dengan format yang benar
  String generatePdfFileName(Map<String, dynamic> userData) {
    final nrp = userData['nrp'] ?? '00000';
    final randomNumber =
        (10000 + (DateTime.now().millisecondsSinceEpoch % 90000)).toString();
    return 'surat_cuti_${nrp}_$randomNumber.pdf';
  }

  // Konversi angka ke kata dalam bahasa Indonesia (capitalize)
  String angkaKeKataIndonesia(int n) {
    if (n < 0) return n.toString();
    const units = [
      'Nol',
      'Satu',
      'Dua',
      'Tiga',
      'Empat',
      'Lima',
      'Enam',
      'Tujuh',
      'Delapan',
      'Sembilan',
      'Sepuluh',
      'Sebelas',
      'Dua Belas',
      'Tiga Belas',
      'Empat Belas',
      'Lima Belas',
      'Enam Belas',
      'Tujuh Belas',
      'Delapan Belas',
      'Sembilan Belas',
    ];
    const tens = [
      '',
      'Sepuluh',
      'Dua Puluh',
      'Tiga Puluh',
      'Empat Puluh',
      'Lima Puluh',
      'Enam Puluh',
      'Tujuh Puluh',
      'Delapan Puluh',
      'Sembilan Puluh',
    ];
    if (n < 20) return units[n];
    if (n < 100) {
      final d = n ~/ 10;
      final r = n % 10;
      if (r == 0) return tens[d];
      return '${tens[d]} ${units[r]}';
    }
    if (n < 1000) {
      final h = n ~/ 100;
      final r = n % 100;
      final hundredWord = h == 1 ? 'Seratus' : '${units[h]} Ratus';
      if (r == 0) return hundredWord;
      return '$hundredWord ${angkaKeKataIndonesia(r)}';
    }
    return n.toString();
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

  // Ambil data pengguna langsung dari tabel users (termasuk sisa_cuti)
  Future<Map<String, dynamic>?> fetchCurrentUserWithSisaCuti() async {
    try {
      final loginUser = cutiController.loginController.currentUser.value;
      if (loginUser == null) {
        return cutiController.currentUser.value;
      }
      final result = await supabaseService.client
          .from('users')
          .select()
          .eq('id', loginUser['id'])
          .single();
      return result;
    } catch (e) {
      // fallback ke state yang sudah dimuat jika ada
      return cutiController.currentUser.value;
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

  Future<Uint8List> generateCutiPdf(Map<String, dynamic> cutiData) async {
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
      final tanggalPengajuan = cutiData['tanggal_pengajuan'] != null
          ? DateTime.parse(cutiData['tanggal_pengajuan'])
          : DateTime.now();

      final formattedDate = DateFormat(
        'dd MMMM yyyy',
        'id_ID',
      ).format(tanggalPengajuan);

      // Get user data (pastikan memuat sisa_cuti)
      final userData = await fetchCurrentUserWithSisaCuti();
      final nama = userData?['name'] ?? 'Nama Pegawai';
      final nip = userData?['nrp'] ?? 'NRP Pegawai';
      final kontak = userData?['kontak'] ?? '-';
      final jabatan = userData?['jabatan'] ?? 'Jabatan Pegawai';
      final userStatus = userData?['status'] ?? 'Operasional';
      // Sisa cuti dari tabel users
      final sisaCutiUser =
          (userData?['sisa_cuti'] ?? cutiController.sisaCuti.value ?? 0)
              .toString();

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

      // Get cuti details
      final lamaCuti = cutiData['lama_cuti'] ?? 0;
      final listTanggalCuti = cutiData['list_tanggal_cuti'] ?? '';

      // Parse tanggal cuti
      final tanggalCutiList = listTanggalCuti.isNotEmpty
          ? listTanggalCuti.split(',').map((e) => e.trim()).toList()
          : <String>[];

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
                  'Perihal: Permohonan Cuti Tahunan',
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
                    0: pw.FixedColumnWidth(140),
                    1: pw.FixedColumnWidth(10),
                    2: pw.FlexColumnWidth(),
                  },
                  children: [
                    _buildTableRow('Nama', ':', nama),
                    _buildTableRow('NRP', ':', nip),
                    _buildTableRow('Nomor HP / WA', ':', kontak),
                    _buildTableRow('Jabatan', ':', jabatan),
                  ],
                ),

                pw.SizedBox(height: 15),

                // Intro paragraph with bold for count and date range
                pw.RichText(
                  text: () {
                    // Gunakan jumlah tanggal cuti jika ada, fallback ke lamaCuti
                    final hariCount = tanggalCutiList.isNotEmpty
                        ? tanggalCutiList.length
                        : (lamaCuti is int
                              ? lamaCuti
                              : int.tryParse(lamaCuti.toString()) ?? 0);
                    String rentang = '';
                    if (tanggalCutiList.isNotEmpty) {
                      try {
                        final first = DateTime.parse(tanggalCutiList.first);
                        final last = DateTime.parse(tanggalCutiList.last);
                        final firstStr = DateFormat(
                          'dd MMMM yyyy',
                          'id_ID',
                        ).format(first);
                        final lastStr = DateFormat(
                          'dd MMMM yyyy',
                          'id_ID',
                        ).format(last);
                        rentang = '$firstStr s.d $lastStr';
                      } catch (_) {}
                    }
                    return pw.TextSpan(
                      style: pw.TextStyle(fontSize: 11),
                      children: [
                        pw.TextSpan(
                          text:
                              'Dengan ini mengajukan permintaan ijin cuti tahunan selama ',
                        ),
                        pw.TextSpan(
                          text:
                              '$hariCount (${angkaKeKataIndonesia(hariCount)})',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.TextSpan(text: ' hari kerja, pada tanggal '),
                        pw.TextSpan(
                          text: rentang,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.TextSpan(
                          text:
                              '. Selama menjalankan cuti alamat saya di Pontianak.',
                        ),
                      ],
                    );
                  }(),
                ),

                pw.SizedBox(height: 10),

                // Horizontal dates table like the example
                pw.Table(
                  border: pw.TableBorder.all(width: 1),
                  columnWidths: {
                    0: pw.FixedColumnWidth(80),
                    // dynamic columns for each date
                    for (var i = 1; i <= (tanggalCutiList.length); i++)
                      i: pw.FlexColumnWidth(),
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(6),
                          child: pw.Text(
                            'Tanggal',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        ...tanggalCutiList.map((t) {
                          String day = t;
                          try {
                            day = DateFormat(
                              'd',
                              'id_ID',
                            ).format(DateTime.parse(t));
                          } catch (_) {}
                          return pw.Padding(
                            padding: pw.EdgeInsets.all(6),
                            child: pw.Text(
                              day,
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(6),
                          child: pw.Text(
                            'Ket.',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        ...tanggalCutiList
                            .map(
                              (_) => pw.Padding(
                                padding: pw.EdgeInsets.all(6),
                                child: pw.Text(
                                  'C',
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ],
                ),

                pw.SizedBox(height: 15),

                // Summary bagian dihapus sesuai permintaan (tidak menampilkan Lama Cuti & Alasan Cuti)
                pw.SizedBox(height: 8),

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

                // Approval & notes table (bottom)
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
                            'CATATAN PEJABAT PERSONALIA',
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
                            'KEPUTUSAN PEJABAT YANG BERWENANG MEMBERIKAN CUTI',
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
                          height: 80,
                          padding: pw.EdgeInsets.all(6),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Cuti yang telah diambil dalam tahun yang bersangkutan:',
                                style: pw.TextStyle(fontSize: 7),
                              ),
                              pw.SizedBox(height: 4),
                              pw.Text(
                                '1. Cuti Tahun : ${tanggalCutiList.isNotEmpty ? DateTime.tryParse(tanggalCutiList.first)?.year ?? tanggalPengajuan.year : tanggalPengajuan.year}',
                                style: pw.TextStyle(fontSize: 7),
                              ),
                              pw.Text(
                                '2. Cuti Alasan Penting : -',
                                style: pw.TextStyle(fontSize: 7),
                              ),
                              pw.Text(
                                '3. Lama Cuti : ${tanggalCutiList.length} Hari',
                                style: pw.TextStyle(fontSize: 7),
                              ),
                              pw.Text(
                                '4. Sisa Cuti : $sisaCutiUser Hari',
                                style: pw.TextStyle(fontSize: 7),
                              ),
                            ],
                          ),
                        ),
                        pw.Container(
                          height: 60,
                          padding: pw.EdgeInsets.all(6),
                          child: pw.Column(
                            children: [
                              pw.Text(
                                supervisorJabatan.toUpperCase(),
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                              pw.Spacer(),
                              pw.SizedBox(height: 10),
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
                            children: [
                              pw.Text(
                                managerJabatan.toUpperCase(),
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                              pw.Spacer(),
                              pw.SizedBox(height: 10),
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

      await Share.shareXFiles([XFile(file.path)], text: 'Dokumen Cuti');
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
