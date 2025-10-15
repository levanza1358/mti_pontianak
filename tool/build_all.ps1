param(
  [string]$BaseHref = "/mti_pontianak/",
  [switch]$Push,
  [switch]$Clean
)

Write-Host "== MTI Pontianak: Build Android APK + Web to docs =="

# Fail fast on errors
$ErrorActionPreference = "Stop"

function Exec($cmd) {
  Write-Host "-> $cmd"
  iex $cmd
}

try {
  # Show versions
  Exec "flutter --version"
  Exec "git --version"

  if ($Clean) {
    Write-Host "Cleaning project..."
    Exec "flutter clean"
    Exec "flutter pub get"
  }

  # Build Android APK (release)
  Write-Host ""
  Write-Host "Building Android APK (release)..." -ForegroundColor Yellow
  # Pass GITHUB_TOKEN via dart-define if available
  $defineArg = ""
  if ($env:GITHUB_TOKEN) { $defineArg = "--dart-define=GITHUB_TOKEN=$($env:GITHUB_TOKEN)" }
  Exec "flutter build apk --release $defineArg"

  # Show APK info
  $apkDir = "android\app\build\outputs\apk\release"
  if (Test-Path $apkDir) {
    $apkFile = Get-ChildItem -Path $apkDir -Filter "*.apk" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($apkFile) {
      Write-Host "APK berhasil dibuat: $($apkFile.Name)" -ForegroundColor Green
      Write-Host "  Lokasi: $($apkFile.FullName)"
      Write-Host "  Ukuran: $([math]::Round($apkFile.Length / 1MB, 2)) MB"
    }
  }

  # Build Web (release) with base href
  Write-Host ""
  Write-Host "Building Web (release) dengan base-href '$BaseHref'..." -ForegroundColor Yellow
  Exec "flutter build web --release --base-href `"$BaseHref`" $defineArg"

  # Sync build/web to docs
  Write-Host "Menyalin build/web -> docs..."
  if (Test-Path "docs") { 
    Write-Host "Menghapus folder docs lama..."
    Remove-Item -Recurse -Force "docs" 
  }
  New-Item -ItemType Directory -Force "docs" | Out-Null
  Copy-Item -Path "build/web/*" -Destination "docs" -Recurse -Force

  Write-Host "Web build berhasil disalin ke folder docs!" -ForegroundColor Green

  # Stage changes (docs and latest APK)
  Write-Host ""
  Write-Host "Staging perubahan untuk git..."
  Exec "git add docs"
  
  if (Test-Path $apkDir) {
    $apkFile = Get-ChildItem -Path $apkDir -Filter "*.apk" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($apkFile) {
      Exec "git add `"$($apkFile.FullName)`""
      Write-Host "Staged APK: $($apkFile.Name)"
    }
  }

  # Commit (ignore if nothing to commit)
  $shortRev = (& git rev-parse --short HEAD)
  $dt = Get-Date -Format "yyyy-MM-dd HH:mm"
  try {
    Exec "git commit -m `"build: android apk + web->docs ($dt, $shortRev)`""
    Write-Host "Perubahan berhasil di-commit!" -ForegroundColor Green
  } catch {
    Write-Host "Tidak ada perubahan untuk di-commit atau commit gagal: $($_.Exception.Message)" -ForegroundColor Yellow
  }

  if ($Push) {
    $branch = (& git rev-parse --abbrev-ref HEAD)
    Write-Host "Pushing ke origin/$branch..."
    Exec "git push origin $branch"
    Write-Host "Berhasil push ke GitHub!" -ForegroundColor Green
  } else {
    Write-Host "Jalankan dengan parameter -Push untuk otomatis push ke GitHub" -ForegroundColor Cyan
  }

  Write-Host ""
  Write-Host "Build selesai!" -ForegroundColor Green
  Write-Host "APK tersedia di: android/app/build/outputs/apk/release/" -ForegroundColor Cyan
  Write-Host "Web tersedia di: docs/" -ForegroundColor Cyan
  Write-Host "Setelah push, web akan tersedia di: https://levanza1358.github.io$BaseHref" -ForegroundColor Cyan

} catch {
  Write-Error "Build script gagal: $($_.Exception.Message)"
  exit 1
}