param(
  [string]$BaseHref = "/mti_pontianak/",
  [switch]$Push
)

Write-Host "== MTI Pontianak: Build APK + Web to docs =="

# Fail fast on errors
$ErrorActionPreference = "Stop"

function Exec($cmd) {
  Write-Host "→ $cmd"
  iex $cmd
}

try {
  # Prepare
  Exec "flutter --version"
  Exec "git --version"

  Write-Host "Cleaning and fetching deps..."
  Exec "flutter clean"
  Exec "flutter pub get"

  # Build Android APK (release)
  Write-Host "Building Android APK (release)..."
  Exec "flutter build apk --release"

  # Build Web (release) with base href
  Write-Host "Building Web (release) with base-href '$BaseHref'..."
  Exec "flutter build web --release --base-href \"$BaseHref\""

  # Sync build/web to docs
  Write-Host "Syncing build/web → docs..."
  if (Test-Path "docs") { Remove-Item -Recurse -Force "docs" }
  New-Item -ItemType Directory -Force "docs" | Out-Null
  Copy-Item -Path "build/web/*" -Destination "docs" -Recurse -Force

  # Stage changes (docs and latest APK)
  Write-Host "Staging changes..."
  Exec "git add docs"
  $apkDir = "android\app\build\outputs\apk\release"
  if (Test-Path $apkDir) {
    $apkFile = Get-ChildItem -Path $apkDir -Filter "*.apk" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($apkFile) {
      Exec "git add \"$($apkFile.FullName)\""
      Write-Host "Staged APK: $($apkFile.Name)"
    }
  }

  # Commit (ignore if nothing to commit)
  $shortRev = (& git rev-parse --short HEAD)
  $dt = Get-Date -Format "yyyy-MM-dd HH:mm"
  try {
    Exec "git commit -m \"build: web→docs, apk ($dt, $shortRev)\""
  } catch {
    Write-Host "No changes to commit or commit failed: $($_.Exception.Message)"
  }

  if ($Push) {
    $branch = (& git rev-parse --abbrev-ref HEAD)
    Write-Host "Pushing to origin/$branch..."
    Exec "git push origin $branch"
  } else {
    Write-Host "Skipping git push (run with -Push to push)."
  }

  Write-Host "Done."
} catch {
  Write-Error "Build script failed: $($_.Exception.Message)"
  exit 1
}