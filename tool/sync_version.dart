import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  final repoRoot = Directory.current.path;
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    stderr.writeln('pubspec.yaml tidak ditemukan di $repoRoot');
    exitCode = 1;
    return;
  }

  final lines = await pubspecFile.readAsLines();

  String? packageName;
  String? versionRaw;

  for (final raw in lines) {
    final line = raw.trim();
    if (line.startsWith('#')) continue;
    if (packageName == null && line.startsWith('name:')) {
      packageName = line.replaceFirst('name:', '').trim();
      continue;
    }
    if (versionRaw == null && line.startsWith('version:')) {
      versionRaw = line.replaceFirst('version:', '').trim();
      continue;
    }
    if (packageName != null && versionRaw != null) break;
  }

  if (packageName == null) {
    stderr.writeln('Gagal menemukan field name di pubspec.yaml');
    exitCode = 2;
    return;
  }

  if (versionRaw == null) {
    stderr.writeln('Gagal menemukan field version di pubspec.yaml');
    exitCode = 3;
    return;
  }

  // Pisahkan versi dan build number (x.y.z+build)
  String version = versionRaw;
  String buildNumber = '';
  final plusIndex = versionRaw.indexOf('+');
  if (plusIndex >= 0) {
    version = versionRaw.substring(0, plusIndex);
    buildNumber = versionRaw.substring(plusIndex + 1);
  }

  // Tentukan app_name dari web/manifest.json jika ada, jika tidak format dari packageName
  String appName = _titleCase(packageName.replaceAll('_', ' '));
  final manifestFile = File('web/manifest.json');
  if (manifestFile.existsSync()) {
    try {
      final manifestJson = json.decode(await manifestFile.readAsString());
      if (manifestJson is Map &&
          (manifestJson['name'] ?? '').toString().isNotEmpty) {
        appName = manifestJson['name'].toString();
      }
    } catch (_) {
      // abaikan dan gunakan default appName
    }
  }

  // Tulis web/version.json
  final versionJsonFile = File('web/version.json');
  final data = {
    'app_name': appName,
    'version': version,
    'build_number': buildNumber,
    'package_name': packageName,
  };

  final encoder = const JsonEncoder.withIndent('  ');
  await versionJsonFile.create(recursive: true);
  await versionJsonFile.writeAsString('${encoder.convert(data)}\n');

  stdout.writeln('Berhasil sync web/version.json -> ${versionJsonFile.path}');
  stdout.writeln(
      'app_name=$appName, version=$version, build_number=${buildNumber.isEmpty ? '(kosong)' : buildNumber}, package_name=$packageName');
}

String _titleCase(String input) {
  if (input.trim().isEmpty) return input;
  return input
      .split(RegExp(r'\s+'))
      .map((w) => w.isEmpty ? w : (w[0].toUpperCase() + w.substring(1)))
      .join(' ')
      .trim();
}
