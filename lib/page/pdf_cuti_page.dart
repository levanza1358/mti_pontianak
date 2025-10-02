import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'dart:math';
import '../controller/pdf_cuti_controller.dart';

class PdfCutiPage extends StatelessWidget {
  final Map<String, dynamic> cutiData;

  const PdfCutiPage({Key? key, required this.cutiData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PdfCutiController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Dokumen Cuti'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final pdfBytes = await controller.generateCutiPdf(cutiData);
              if (pdfBytes.isNotEmpty) {
                final userData = controller.cutiController.currentUser.value;
                final fileName = controller.generatePdfFileName(userData ?? {});
                await controller.sharePdf(
                  pdfBytes,
                  fileName,
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: () async {
              final pdfBytes = await controller.generateCutiPdf(cutiData);
              if (pdfBytes.isNotEmpty) {
                final userData = controller.cutiController.currentUser.value;
                final fileName = controller.generatePdfFileName(userData ?? {});
                await controller.savePdfToDevice(
                  pdfBytes,
                  fileName,
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              final pdfBytes = await controller.generateCutiPdf(cutiData);
              if (pdfBytes.isNotEmpty) {
                await controller.printPdf(pdfBytes);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: controller.generateCutiPdf(cutiData),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || (snapshot.data as List<int>).isEmpty) {
            return const Center(child: Text('Tidak dapat membuat PDF'));
          }

          return PdfPreview(
            build: (format) => snapshot.data as Uint8List,
            canChangeOrientation: false,
            canChangePageFormat: false,
            canDebug: false,
            useActions: false, // Menghilangkan semua tombol bawah
          );
        },
      ),
    );
  }
}