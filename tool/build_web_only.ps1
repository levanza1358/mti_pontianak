param(
  [string]$BaseHref = "/mti_pontianak/",
  [switch]$Clean
)

Write-Host "== MTI Pontianak: Build Web to docs (Manual Git) =="

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

  # Build Web (release) with base href
  Write-Host "Building Web (release) dengan base-href '$BaseHref'..."
  Exec "flutter build web --release --base-href `"$BaseHref`""

  # Sync build/web to docs
  Write-Host "Menyalin build/web -> docs..."
  if (Test-Path "docs") { 
    Write-Host "Menghapus folder docs lama..."
    Remove-Item -Recurse -Force "docs" 
  }
  New-Item -ItemType Directory -Force "docs" | Out-Null
  Copy-Item -Path "build/web/*" -Destination "docs" -Recurse -Force

  Write-Host "Web build berhasil disalin ke folder docs!" -ForegroundColor Green

  Write-Host ""
  Write-Host "Web build selesai!" -ForegroundColor Green
  Write-Host "File web tersedia di folder: docs/" -ForegroundColor Cyan
  Write-Host "Setelah push manual, akan tersedia di: https://levanza1358.github.io$BaseHref" -ForegroundColor Cyan
  Write-Host ""
  Write-Host "CATATAN: Script ini TIDAK melakukan commit/push otomatis." -ForegroundColor Yellow
  Write-Host "Anda bisa melakukan git add, commit, dan push secara manual." -ForegroundColor Yellow

} catch {
  Write-Error "Web build gagal: $($_.Exception.Message)"
  exit 1
}