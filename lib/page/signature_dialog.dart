import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

class SignatureDialog extends StatelessWidget {
  final SignatureController signatureController;
  final VoidCallback onSave;
  final VoidCallback onClear;

  const SignatureDialog({
    super.key,
    required this.signatureController,
    required this.onSave,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.7,
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
                      onClear();
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
                      onSave();
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
    );
  }
}
