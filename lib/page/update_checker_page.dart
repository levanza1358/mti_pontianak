import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/update_checker_controller.dart';

class UpdateCheckerPage extends StatelessWidget {
  const UpdateCheckerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(UpdateCheckerController());
    const primaryGradient = [Color(0xFF667eea), Color(0xFF764ba2)];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: primaryGradient.map((c) => c.withOpacity(0.08)).toList(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Obx(
            () => Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: primaryGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x26667eea),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cek Pembaruan Aplikasi',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Periksa versi terbaru dan pasang pembaruan',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _infoCard('Versi Saat Ini', c.currentVersion.value),
                        const SizedBox(height: 12),
                        _infoCard(
                          'Versi Terbaru',
                          c.latestVersion.value.isEmpty
                              ? '-'
                              : c.latestVersion.value,
                        ),
                        const SizedBox(height: 12),
                        _notesCard(c.releaseName.value, c.releaseNotes.value),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: c.isChecking.value
                                    ? null
                                    : c.checkForUpdate,
                                icon: const Icon(Icons.system_update_rounded),
                                label: Text(
                                  c.isChecking.value
                                      ? 'Memeriksa...'
                                      : 'Cek Pembaruan',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (c.isUpdateAvailable.value)
                          ElevatedButton.icon(
                            onPressed: c.isDownloading.value
                                ? null
                                : c.downloadAndInstall,
                            icon: const Icon(Icons.download_rounded),
                            label: Text(
                              c.isDownloading.value
                                  ? (c.progressText.value.isNotEmpty
                                        ? 'Mengunduh ${c.progressText.value}'
                                        : 'Mengunduh...')
                                  : 'Unduh & Pasang',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF22c55e),
                            ),
                          ),
                        if (c.errorText.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              'Error: ${c.errorText.value}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Color(0xFF718096)),
          ),
          const SizedBox(height: 6),
          Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notesCard(String name, String notes) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rilis Terbaru',
            style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
          ),
          const SizedBox(height: 6),
          Text(
            name.isEmpty ? '-' : name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            notes.isEmpty ? 'Belum ada catatan rilis.' : notes,
            style: const TextStyle(fontSize: 13, color: Color(0xFF4A5568)),
          ),
        ],
      ),
    );
  }
}
