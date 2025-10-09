import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_tokens.dart';

class UpdateCheckerController extends GetxController {
  final isChecking = false.obs;
  final isDownloading = false.obs;
  final downloadPercent = 0.0.obs; // 0.0 - 1.0
  
  final currentVersion = ''.obs;
  final latestVersion = ''.obs;
  final releaseName = ''.obs;
  final releaseNotes = ''.obs;
  final releasePageUrl = ''.obs;
  final apkDownloadUrl = ''.obs;

  final progressText = ''.obs; // e.g., 35%
  final errorText = ''.obs;
  final isUpdateAvailable = false.obs;
  bool _autoChecked = false;

  static const _releasesApi =
      'https://api.github.com/repos/levanza1358/mti_pontianak/releases/latest';

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadCurrentVersion();
    await _cleanupDownloadedApkIfUpdated();
  }

  Future<void> _loadCurrentVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      // Display as x.y.z+build if available
      final ver = info.version.trim();
      final build = info.buildNumber.trim();
      currentVersion.value = build.isNotEmpty ? '$ver+$build' : ver;
    } catch (_) {
      currentVersion.value = '-';
    }
  }

  Future<void> checkForUpdate() async {
    isChecking.value = true;
    errorText.value = '';
    try {
      final resp = await http.get(
        Uri.parse(_releasesApi),
        headers: {
          'Accept': 'application/vnd.github+json',
          'X-GitHub-Api-Version': '2022-11-28',
          'User-Agent': 'mti-pontianak-app',
        },
      );

      if (resp.statusCode != 200) {
        throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
      }

      final data = json.decode(resp.body) as Map<String, dynamic>;
      final tag = (data['tag_name'] ?? '').toString();
      final name = (data['name'] ?? tag).toString();
      final body = (data['body'] ?? '').toString();
      final htmlUrl = (data['html_url'] ?? '').toString();
      String apkUrl = '';

      final assets = (data['assets'] as List<dynamic>? ?? []);
      for (final a in assets) {
        final m = a as Map<String, dynamic>;
        final assetName = (m['name'] ?? '').toString().toLowerCase();
        if (assetName.endsWith('.apk')) {
          apkUrl = (m['browser_download_url'] ?? '').toString();
          break;
        }
      }

      latestVersion.value = tag.isNotEmpty ? tag : name;
      releaseName.value = name;
      releaseNotes.value = body;
      releasePageUrl.value = htmlUrl;
      apkDownloadUrl.value = apkUrl;

      isUpdateAvailable.value = _isNewerVersion(
        latestVersion.value,
        currentVersion.value,
      );

      if (!isUpdateAvailable.value) {
        final tokens = Get.theme.extension<AppTokens>()!;
        Get.snackbar(
          'Up to date',
          'Aplikasi sudah versi terbaru',
          backgroundColor: tokens.successBg,
          colorText: tokens.successFg,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      errorText.value = e.toString();
      final tokens = Get.theme.extension<AppTokens>()!;
      Get.snackbar(
        'Error',
        'Gagal memeriksa pembaruan: $e',
        backgroundColor: tokens.dangerBg,
        colorText: tokens.dangerFg,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isChecking.value = false;
    }
  }

  // Dipanggil dari Home sekali saja
  Future<void> checkOnHomeOnce() async {
    if (_autoChecked) return;
    _autoChecked = true;
    await checkForUpdate();
    if (isUpdateAvailable.value) {
      promptUpdate();
    }
  }

  void promptUpdate() {
    Get.dialog(
      AlertDialog(
        title: const Text('Pembaruan Tersedia'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Versi saat ini: ${currentVersion.value.isEmpty ? '-' : currentVersion.value}'),
            Text('Versi terbaru: ${latestVersion.value.isEmpty ? '-' : latestVersion.value}'),
            const SizedBox(height: 8),
            Text('Catatan rilis:', style: TextStyle(color: Get.theme.extension<AppTokens>()!.textSecondary)),
            const SizedBox(height: 4),
            SingleChildScrollView(
              child: Text(
                releaseNotes.value.isEmpty ? '-' : releaseNotes.value,
                style: TextStyle(fontSize: 12, color: Get.theme.extension<AppTokens>()!.textSecondary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Nanti')),
          ElevatedButton.icon(
            onPressed: () {
              Get.back();
              _startDownloadWithDialog();
            },
            icon: const Icon(Icons.system_update_rounded),
            label: const Text('Update Sekarang'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _startDownloadWithDialog() {
    Get.dialog(
      Obx(() => AlertDialog(
            title: const Text('Mengunduh Pembaruan'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: isDownloading.value && downloadPercent.value > 0
                      ? downloadPercent.value
                      : null,
                ),
                const SizedBox(height: 8),
                Text(isDownloading.value
                    ? 'Progress: ${progressText.value}'
                    : (errorText.value.isNotEmpty
                        ? 'Gagal: ${errorText.value}'
                        : 'Selesai, membuka installer...')),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isDownloading.value ? null : () => Get.back(),
                child: const Text('Tutup'),
              ),
            ],
          )),
      barrierDismissible: false,
    );
    downloadAndInstall();
  }

  bool _isNewerVersion(String latest, String current) {
    // Strip leading 'v' and compare semver lexically with padding fallback.
    String norm(String v) =>
        v.trim().toLowerCase().replaceFirst(RegExp(r'^v'), '');
    final l = norm(latest);
    final c = norm(current);
    if (l == c) return false;
    // Try numeric compare on major.minor.patch
    List<int> toParts(String v) {
      final core = v.split('+').first; // ignore build metadata
      final parts = core.split('.');
      return List<int>.generate(
        3,
        (i) => i < parts.length ? int.tryParse(parts[i]) ?? 0 : 0,
      );
    }

    final lp = toParts(l);
    final cp = toParts(c);
    for (int i = 0; i < 3; i++) {
      if (lp[i] != cp[i]) return lp[i] > cp[i];
    }
    // If numeric parts are equal, ignore build metadata differences like "+1"
    // Treat versions as equal to avoid false update prompts (e.g., 1.0.0+1 vs 1.0.0)
    return false;
  }

  Future<void> downloadAndInstall() async {
    final url = apkDownloadUrl.value;
    if (url.isEmpty) {
      // Fallback: open release page
      if (releasePageUrl.value.isNotEmpty) {
        await launchUrlString(releasePageUrl.value, mode: LaunchMode.externalApplication);
      }
      return;
    }

    // In-app download with progress; then trigger installer
    try {
      isDownloading.value = true;
      downloadPercent.value = 0.0;
      progressText.value = '0%';
      errorText.value = '';

      final dio = Dio();
      final dir = await getTemporaryDirectory();
      final versionTag = latestVersion.value.isEmpty ? 'update' : latestVersion.value;
      final filePath = '${dir.path}/mti_pontianak-$versionTag.apk';

      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final p = received / total;
            downloadPercent.value = p;
            final pct = (p * 100).clamp(0, 100).toStringAsFixed(0);
            progressText.value = '$pct%';
          }
        },
        options: Options(followRedirects: true, receiveTimeout: const Duration(minutes: 10)),
      );

      // Simpan marker untuk cleanup setelah instal
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pending_apk_path', filePath);
        await prefs.setString('pending_apk_version', versionTag);
      } catch (_) {}

      if (Platform.isAndroid) {
        await OpenFilex.open(filePath);
      } else {
        await launchUrlString(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      errorText.value = e.toString();
      final tokens = Get.theme.extension<AppTokens>()!;
      Get.snackbar(
        'Error',
        'Gagal mengunduh/memasang pembaruan: $e',
        backgroundColor: tokens.dangerBg,
        colorText: tokens.dangerFg,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isDownloading.value = false;
    }
  }

  Future<void> _cleanupDownloadedApkIfUpdated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingPath = prefs.getString('pending_apk_path');
      final pendingVersion = prefs.getString('pending_apk_version') ?? '';
      if (pendingPath == null || pendingPath.isEmpty) return;

      final info = await PackageInfo.fromPlatform();
      final currentVer = info.version.trim();
      if (currentVer.isEmpty) return;

      // Jika versi aplikasi sudah sama/lebih baru dari versi pending, hapus file
      bool shouldDelete = false;
      if (pendingVersion.isEmpty) {
        shouldDelete = true;
      } else {
        // compare semver major.minor.patch
        int cmp(String a, String b) {
          List<int> p(String v) {
            final core = v.split('+').first;
            final s = core.split('.');
            return List<int>.generate(3, (i) => i < s.length ? int.tryParse(s[i]) ?? 0 : 0);
          }
          final ap = p(a), bp = p(b);
          for (int i = 0; i < 3; i++) {
            if (ap[i] != bp[i]) return ap[i] - bp[i];
          }
          return 0;
        }
        shouldDelete = cmp(currentVer, pendingVersion) >= 0;
      }

      if (shouldDelete) {
        final f = File(pendingPath);
        if (await f.exists()) {
          await f.delete();
        }
        await prefs.remove('pending_apk_path');
        await prefs.remove('pending_apk_version');
      }
    } catch (_) {
      // ignore
    }
  }
}
