# mti_pontianak

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Build Otomatis: APK + Web ke `docs`

Untuk otomatisasi build APK dan Web (hasil Web langsung disalin ke folder `docs` dan siap di-push), gunakan skrip dan task yang sudah disiapkan:

- Jalankan dari VSCode: `Terminal` → `Run Build Task…` → pilih `Build APK + Web to docs (push)`.
- Atau jalankan manual dari terminal PowerShell di root proyek:

```
powershell -ExecutionPolicy Bypass -File .\tool\build_all.ps1 -BaseHref "/mti_pontianak/" -Push
```

Penjelasan skrip:
- `flutter build apk --release` untuk APK.
- `flutter build web --release --base-href "/mti_pontianak/"` untuk Web.
- Hasil `build/web` disalin ke `docs/` agar GitHub Pages (Source: `main` → `/(docs)`) langsung menayangkan.
- Opsi `-Push` akan melakukan `git add`, `commit` (jika ada perubahan) dan `git push` ke branch saat ini.

Catatan:
- Pastikan `Settings → Pages` repo ini menggunakan `Branch: main` dan `Folder: /(docs)`.
- Jika hanya ingin build tanpa push, hilangkan `-Push` atau gunakan task `Build APK + Web to docs (no push)`.
