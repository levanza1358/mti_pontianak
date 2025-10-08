import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdateCheckerController extends GetxController {
  final isChecking = false.obs;
  final isDownloading = false.obs;

  final currentVersion = ''.obs;
  final latestVersion = ''.obs;
  final releaseName = ''.obs;
  final releaseNotes = ''.obs;
  final releasePageUrl = ''.obs;
  final apkDownloadUrl = ''.obs;

  final progressText = ''.obs; // e.g., 35%
  final errorText = ''.obs;
  final isUpdateAvailable = false.obs;

  static const _releasesApi =
      'https://api.github.com/repos/levanza1358/mti_pontianak/releases/latest';

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadCurrentVersion();
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
        },
      );

      if (resp.statusCode != 200) {
        throw Exception('HTTP ${resp.statusCode}');
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
        Get.snackbar(
          'Up to date',
          'Aplikasi sudah versi terbaru',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      errorText.value = e.toString();
      Get.snackbar(
        'Error',
        'Gagal memeriksa pembaruan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isChecking.value = false;
    }
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
    // If numeric equal but strings differ, treat tag as newer
    return l != c;
  }

  Future<void> downloadAndInstall() async {
    final url = apkDownloadUrl.value;
    if (url.isEmpty) {
      // Fallback: open release page
      if (releasePageUrl.value.isNotEmpty) {
        await launchUrlString(
          releasePageUrl.value,
          mode: LaunchMode.externalApplication,
        );
      }
      return;
    }

    if (!Platform.isAndroid) {
      // Only Android supports direct APK install; open in browser otherwise
      await launchUrlString(url, mode: LaunchMode.externalApplication);
      return;
    }

    try {
      isDownloading.value = true;
      progressText.value = '0%';
      errorText.value = '';

      final stream = OtaUpdate().execute(
        url,
        destinationFilename: 'mti_pontianak-${latestVersion.value}.apk',
      );

      await for (final event in stream) {
        switch (event.status) {
          case OtaStatus.DOWNLOADING:
            progressText.value = '${event.value ?? '0'}%';
            break;
          case OtaStatus.INSTALLING:
            progressText.value = 'Memasang...';
            break;
          case OtaStatus.ALREADY_RUNNING_ERROR:
          case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
          case OtaStatus.INTERNAL_ERROR:
          case OtaStatus.DOWNLOAD_ERROR:
          case OtaStatus.CHECKSUM_ERROR:
            errorText.value = event.value ?? 'Terjadi kesalahan saat mengunduh';
            isDownloading.value = false;
            Get.snackbar(
              'Error',
              errorText.value,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
            );
            return;
        }
      }
      // Stream selesai tanpa error: anggap selesai/ditangani oleh installer
      isDownloading.value = false;
    } catch (e) {
      isDownloading.value = false;
      errorText.value = e.toString();
      Get.snackbar(
        'Error',
        'Gagal mengunduh/memasang pembaruan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
