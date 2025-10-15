<p align="center">
  <img src="assets/MTI_logo.png" alt="MTI Pontianak" width="120" />
</p>

<h1 align="center">MTI Pontianak</h1>
<p align="center">Aplikasi internal untuk manajemen pegawai, cuti, insentif, dan administrasi.</p>
<p align="center">
  <a href="https://github.com/levanza1358/mti_pontianak/actions/workflows/build-and-deploy.yml"><img src="https://github.com/levanza1358/mti_pontianak/actions/workflows/build-and-deploy.yml/badge.svg" alt="Build & Deploy"></a>
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20Web-3DDC84" alt="Platform">
</p>

## Ringkas

MTI Pontianak adalah aplikasi Flutter yang mendukung operasional harian seperti pengelolaan data pegawai, cuti/eksepsi, insentif, surat keluar, dan manajemen grup/supervisor. Aplikasi tersedia untuk Android (APK) dan Web (static build via GitHub Pages).

## Fitur Utama

- Autentikasi dan manajemen pengguna
- Data pegawai & jabatan (tambah/edit)
- Cuti dan eksepsi, kalender cuti, ekspor dokumen (PDF)
- Insentif dan ringkasan semua insentif
- Surat keluar
- Group & supervisor management
- Tema terang/gelap dengan palet khusus
- Cek pembaruan aplikasi (Android) dengan unduh APK langsung
- Build Web statis ke folder `docs/` untuk GitHub Pages

## Cuplikan

Tambahkan screenshot UI di sini agar lebih informatif. Sementara, logo dan ikon aplikasi:

<p align="center">
  <img src="docs/icons/Icon-512.png" alt="Preview Icon" width="120" />
</p>

## Quick Start

Prasyarat:

- `Flutter` (dan Android SDK untuk build APK)
- Konfigurasi Supabase di `lib/config/supabase_config.dart`

Menjalankan secara lokal:

- Android: `flutter run -d android`
- Web (Chrome): `flutter run -d chrome`

## Build & Deploy

Otomatisasi build APK dan Web (hasil Web langsung ke folder `docs` agar siap di-publish GitHub Pages):

- VSCode task: `Terminal` → `Run Build Task…` → pilih `Build APK + Web to docs (push)`
- Manual PowerShell dari root proyek:

```
powershell -ExecutionPolicy Bypass -File .\tool\build_all.ps1 -BaseHref "/mti_pontianak/" -Push
```

Penjelasan skrip:

- `flutter build apk --release` untuk APK
- `flutter build web --release --base-href "/mti_pontianak/"` untuk Web
- Hasil `build/web` disalin ke `docs/` (GitHub Pages: `main` → `/(docs)`) agar langsung tayang
- Opsi `-Push` akan `git add` → `commit` (jika ada perubahan) → `push`

Catatan:

- Pastikan GitHub Pages: `Settings → Pages` menggunakan `Branch: main` dan `Folder: /(docs)`
- Hanya build tanpa push: hilangkan `-Push` atau gunakan task `Build APK + Web to docs (no push)`

## Cek Pembaruan & Rate Limit GitHub

Aplikasi memeriksa versi terbaru dari GitHub Releases. Jika muncul `API rate limit exceeded`, gunakan token GitHub agar kuota lebih tinggi:

- Set environment variable `GITHUB_TOKEN` dengan Personal Access Token (scope minimal `public_repo`)
- Skrip `tool/*.ps1` dan `tool/*.bat` meneruskan token via `--dart-define=GITHUB_TOKEN=...` saat build

Contoh (PowerShell):

```
$env:GITHUB_TOKEN = "ghp_xxxYourTokenHere"
flutter run --dart-define=GITHUB_TOKEN=$env:GITHUB_TOKEN
```

Keamanan: Jangan commit token ke repo. Gunakan scope minimal.

## Perilaku Platform

- Fitur “Cek Pembaruan” dan halaman Update hanya aktif di Android (APK)
- Pada Web, menu Update disembunyikan dan rutenya tidak tersedia

## Struktur Proyek

- `lib/controller/` — logika bisnis (cuti, pegawai, insentif, update checker, dll.)
- `lib/page/` — halaman UI (Home, Settings, Update, dsb.)
- `lib/services/` — integrasi Supabase
- `lib/theme/` — token tema, palet warna, spacing
- `tool/` — skrip build Android/Web dan sinkronisasi versi
- `docs/` — hasil build Web untuk GitHub Pages

## Kontribusi

Kontribusi terbuka: buat issue atau pull request untuk saran fitur, perbaikan bug, atau peningkatan UI/UX.

---

Referensi Flutter:

- [Codelab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter documentation](https://docs.flutter.dev/)
