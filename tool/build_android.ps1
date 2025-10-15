param(
  [switch]$Clean
)

Write-Host "== MTI Pontianak: Build Android APK =="

# Fail fast on errors
$ErrorActionPreference = "Stop"

function Exec($cmd) {
  Write-Host "-> $cmd"
  iex $cmd
}

try {
  # Show versions
  Exec "flutter --version"

  if ($Clean) {
    Write-Host "Cleaning project..."
    Exec "flutter clean"
    Exec "flutter pub get"
  }

  # Build Android APK (release)
  Write-Host "Building Android APK (release)..."
  # Pass GITHUB_TOKEN via dart-define if available to enable authenticated GitHub API
  $defineArg = ""
  if ($env:GITHUB_TOKEN) { $defineArg = "--dart-define=GITHUB_TOKEN=$($env:GITHUB_TOKEN)" }
  Exec "flutter build apk --release $defineArg"

  # Show APK location
  $apkDir = "android\app\build\outputs\apk\release"
  if (Test-Path $apkDir) {
    $apkFile = Get-ChildItem -Path $apkDir -Filter "*.apk" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($apkFile) {
      Write-Host "APK berhasil dibuat: $($apkFile.FullName)" -ForegroundColor Green
      Write-Host "  Ukuran: $([math]::Round($apkFile.Length / 1MB, 2)) MB"
    }
  }

  Write-Host "Android build selesai!" -ForegroundColor Green
} catch {
  Write-Error "Android build gagal: $($_.Exception.Message)"
  exit 1
}