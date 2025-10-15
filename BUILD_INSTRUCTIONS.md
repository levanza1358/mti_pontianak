# MTI Pontianak - Build Instructions

Panduan untuk melakukan build manual aplikasi MTI Pontianak tanpa menggunakan GitHub Actions.

## 📋 Prerequisites

- Flutter SDK (stable channel)
- Git
- PowerShell (Windows)

## 🚀 Build Scripts

### 1. Build Android APK Only

```powershell
# Build APK biasa
.\tool\build_android.ps1

# Build APK dengan clean project terlebih dahulu
.\tool\build_android.ps1 -Clean
```

**Output:** APK akan tersedia di `android/app/build/outputs/apk/release/`

### 2. Build Web Only (ke folder docs)

```powershell
# Build web biasa
.\tool\build_web.ps1

# Build web dengan clean project
.\tool\build_web.ps1 -Clean

# Build web dan langsung push ke GitHub
.\tool\build_web.ps1 -Push

# Build web dengan custom base href
.\tool\build_web.ps1 -BaseHref "/custom-path/"
```

**Output:** Web build akan tersedia di folder `docs/`

### 3. Build Android + Web (All-in-One)

```powershell
# Build keduanya
.\tool\build_all.ps1

# Build dengan clean project
.\tool\build_all.ps1 -Clean

# Build dan langsung push ke GitHub
.\tool\build_all.ps1 -Push

# Build dengan custom base href
.\tool\build_all.ps1 -BaseHref "/custom-path/" -Push
```

**Output:** 
- APK di `android/app/build/outputs/apk/release/`
- Web di `docs/`

## 🌐 Deployment ke GitHub Pages

1. **Build web** menggunakan salah satu script di atas
2. **Push ke GitHub** (manual atau dengan parameter `-Push`)
3. **Aktifkan GitHub Pages** di repository settings:
   - Buka Settings → Pages
   - Source: **Deploy from a branch**
   - Branch: **main**
   - Folder: **/ (root)** atau **docs**

4. **Akses aplikasi** di: `https://levanza1358.github.io/mti_pontianak/`

## 📝 Catatan

- **Folder docs** akan otomatis di-replace setiap kali build web
- **APK** akan di-stage ke git jika menggunakan `build_all.ps1`
- **Base href** default adalah `/mti_pontianak/` sesuai nama repository
- **Clean parameter** akan menjalankan `flutter clean` dan `flutter pub get`
- **Push parameter** akan otomatis commit dan push ke GitHub

## 🔧 Troubleshooting

### Build Gagal
```powershell
# Clean project dan coba lagi
flutter clean
flutter pub get
.\tool\build_android.ps1
```

### Web tidak muncul di GitHub Pages
1. Pastikan folder `docs` sudah di-push ke GitHub
2. Cek GitHub Pages settings di repository
3. Tunggu beberapa menit untuk deployment

### APK tidak bisa diinstall
- Pastikan "Install from unknown sources" diaktifkan di Android
- APK adalah release build, bukan debug build

## 🔒 GitHub API Rate Limit & Cek Pembaruan

Aplikasi melakukan cek versi terbaru melalui GitHub Releases. Tanpa autentikasi, GitHub membatasi sekitar 60 request/jam per IP sehingga kadang muncul error:

```
Exception: HTTP 403: {"message":"API rate limit exceeded ..."}
```

Untuk menghindari hal tersebut:

- Set variabel lingkungan `GITHUB_TOKEN` (Personal Access Token minimal read-only public repos).
- Skrip build di folder `tool/` otomatis meneruskan token ini ke aplikasi via `--dart-define=GITHUB_TOKEN=...`.

Contoh cara set token di PowerShell (hanya untuk sesi terminal saat ini):

```powershell
$env:GITHUB_TOKEN = "ghp_xxxYourTokenHere"
```

Atau permanen di Windows (butuh restart terminal):

```powershell
setx GITHUB_TOKEN "ghp_xxxYourTokenHere"
```

Jika ingin menjalankan aplikasi secara lokal tanpa skrip build, tambahkan `--dart-define` saat run:

```powershell
flutter run --dart-define=GITHUB_TOKEN=$env:GITHUB_TOKEN
```

Catatan keamanan:
- Jangan commit token ke repository.
- Gunakan token dengan scope minimal (public_repo sudah cukup).