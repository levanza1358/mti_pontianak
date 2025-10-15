// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../theme/app_tokens.dart';
import '../controller/update_checker_controller.dart';

class UpdateCheckerPage extends StatelessWidget {
  const UpdateCheckerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<UpdateCheckerController>();
    final theme = Theme.of(context);
    final tokens = theme.extension<AppTokens>()!;
    final primaryGradient = tokens.updateGradient;
    final softText = tokens.textSecondary;
    final strongText = tokens.textPrimary;

    return Scaffold(
      backgroundColor: tokens.bg,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: primaryGradient.map((c) => c.withOpacity(0.14)).toList(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Obx(
            () => Column(
              children: [
                // Header gradient card (match examples)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: primaryGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.25)),
                          ),
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.arrow_back_ios_new,
                                color: Colors.white),
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
                                    fontSize: 13, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white54,
                          radius: 18,
                          child: const Icon(Icons.system_update_rounded,
                              color: Colors.white),
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
                        _infoCard(
                          icon: Icons.phone_android_rounded,
                          iconColor: theme.colorScheme.primary,
                          title: 'Versi Saat Ini',
                          value: c.currentVersion.value,
                          softText: softText,
                          strongText: strongText,
                        ),
                        const SizedBox(height: 12),
                        _infoCard(
                          icon: Icons.cloud_download_rounded,
                          iconColor: tokens.successFg,
                          title: 'Versi Terbaru',
                          value: c.latestVersion.value.isEmpty
                              ? '-'
                              : c.latestVersion.value,
                          softText: softText,
                          strongText: strongText,
                          trailing: c.isUpdateAvailable.value
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: tokens.successBg,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    'Tersedia',
                                    style: TextStyle(
                                      color: tokens.successFg,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 12),
                        _notesCard(
                          name: c.releaseName.value,
                          notes: c.releaseNotes.value,
                          softText: softText,
                          strongText: strongText,
                          onOpenRelease: () {
                            final url = c.releasePageUrl.value;
                            if (url.isNotEmpty) {
                              launchUrlString(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                        ),
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
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (c.isUpdateAvailable.value)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                              if (c.isDownloading.value)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LinearProgressIndicator(
                                        value: c.downloadPercent.value == 0
                                            ? null
                                            : c.downloadPercent.value,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Progress: ${c.progressText.value}',
                                        style: TextStyle(
                                            fontSize: 12, color: softText),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        if (c.errorText.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              'Error: ${c.errorText.value}',
                              style: TextStyle(color: tokens.dangerFg),
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

  Widget _infoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color softText,
    required Color strongText,
    Widget? trailing,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(Get.context!).extension<AppTokens>()!.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 12, color: softText),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value.isEmpty ? '-' : value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: strongText,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _notesCard({
    required String name,
    required String notes,
    required Color softText,
    required Color strongText,
    VoidCallback? onOpenRelease,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(Get.context!).extension<AppTokens>()!.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Theme.of(Get.context!)
                        .extension<AppTokens>()!
                        .warningBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.new_releases_rounded,
                      color: Theme.of(Get.context!)
                          .extension<AppTokens>()!
                          .warningFg),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Rilis Terbaru',
                    style: TextStyle(fontSize: 13, color: softText),
                  ),
                ),
                if (onOpenRelease != null)
                  TextButton.icon(
                    onPressed: onOpenRelease,
                    style: TextButton.styleFrom(
                      foregroundColor:
                          Theme.of(Get.context!).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                    ),
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: const Text('Lihat'),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              name.isEmpty ? '-' : name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: strongText,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(Get.context!).extension<AppTokens>()!.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: SelectableText(
                notes.isEmpty ? 'Belum ada catatan rilis.' : notes,
                style: TextStyle(fontSize: 13, color: softText, height: 1.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
