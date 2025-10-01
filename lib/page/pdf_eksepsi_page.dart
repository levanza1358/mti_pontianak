import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';
import '../controller/pdf_eksepsi_controller.dart';

class PdfEksepsiPage extends StatelessWidget {
  final Map<String, dynamic> eksepsiData;

  const PdfEksepsiPage({Key? key, required this.eksepsiData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PdfEksepsiController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Dokumen Eksepsi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final pdfBytes = await controller.generateEksepsiPdf(eksepsiData);
              if (pdfBytes.isNotEmpty) {
                await controller.sharePdf(
                  pdfBytes,
                  'eksepsi_${DateTime.now().millisecondsSinceEpoch}.pdf',
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: () async {
              final pdfBytes = await controller.generateEksepsiPdf(eksepsiData);
              if (pdfBytes.isNotEmpty) {
                await controller.savePdfToDevice(
                  pdfBytes,
                  'eksepsi_${DateTime.now().millisecondsSinceEpoch}.pdf',
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              final pdfBytes = await controller.generateEksepsiPdf(eksepsiData);
              if (pdfBytes.isNotEmpty) {
                await controller.printPdf(pdfBytes);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: controller.generateEksepsiPdf(eksepsiData),
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
            pdfFileName: 'eksepsi_${DateTime.now().millisecondsSinceEpoch}.pdf',
          );
        },
      ),
    );
  }
}
