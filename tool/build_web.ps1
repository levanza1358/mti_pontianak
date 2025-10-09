param(
  [string]$BaseHref = "/mti_pontianak/",
  [switch]$Clean,
  [switch]$Push
)

Write-Host "== MTI Pontianak: Build Web to docs =="

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

  # Stage changes untuk git
  Write-Host "Staging perubahan docs untuk git..."
  Exec "git add docs"

  # Commit (ignore jika tidak ada yang berubah)
  $shortRev = (& git rev-parse --short HEAD)
  $dt = Get-Date -Format "yyyy-MM-dd HH:mm"
  try {
    Exec "git commit -m `"web: update docs build ($dt, $shortRev)`""
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
  Write-Host "Web build selesai!" -ForegroundColor Green
  Write-Host "File web tersedia di folder: docs/" -ForegroundColor Cyan
  Write-Host "Setelah push, akan tersedia di: https://levanza1358.github.io$BaseHref" -ForegroundColor Cyan

} catch {
  Write-Error "Web build gagal: $($_.Exception.Message)"
  exit 1
}