@echo off
setlocal enabledelayedexpansion

echo == MTI Pontianak: Build Android APK + Web to docs ==

REM Default parameters
set BASE_HREF=/mti_pontianak/
set CLEAN_BUILD=false
set PUSH_TO_GIT=false

REM Parse command line arguments
:parse_args
if "%1"=="" goto start_build
if "%1"=="--clean" set CLEAN_BUILD=true
if "%1"=="-clean" set CLEAN_BUILD=true
if "%1"=="/clean" set CLEAN_BUILD=true
if "%1"=="--push" set PUSH_TO_GIT=true
if "%1"=="-push" set PUSH_TO_GIT=true
if "%1"=="/push" set PUSH_TO_GIT=true
if "%1"=="--base-href" (
    shift
    set BASE_HREF=%2
)
shift
goto parse_args

:start_build
REM Show versions
echo -> flutter --version
flutter --version
if errorlevel 1 (
    echo Error: Flutter tidak ditemukan atau tidak terinstall
    pause
    exit /b 1
)

echo -> git --version
git --version
if errorlevel 1 (
    echo Error: Git tidak ditemukan atau tidak terinstall
    pause
    exit /b 1
)

if "%CLEAN_BUILD%"=="true" (
    echo Cleaning project...
    echo -> flutter clean
    flutter clean
    if errorlevel 1 (
        echo Error: Flutter clean gagal
        pause
        exit /b 1
    )
    
    echo -> flutter pub get
    flutter pub get
    if errorlevel 1 (
        echo Error: Flutter pub get gagal
        pause
        exit /b 1
    )
)

REM Build Android APK (release)
echo.
echo Building Android APK (release)...
echo -> flutter build apk --release
flutter build apk --release
if errorlevel 1 (
    echo Error: Android build gagal
    pause
    exit /b 1
)

REM Show APK info
set APK_DIR=android\app\build\outputs\apk\release
if exist "%APK_DIR%" (
    for %%f in ("%APK_DIR%\*.apk") do (
        echo APK berhasil dibuat: %%~nxf
        echo   Lokasi: %%f
        for %%a in ("%%f") do (
            set /a size_mb=%%~za/1024/1024
            echo   Ukuran: !size_mb! MB
        )
    )
) else (
    echo Warning: APK directory tidak ditemukan
)

REM Build Web (release) with base href
echo.
echo Building Web (release) dengan base-href '%BASE_HREF%'...
echo -> flutter build web --release --base-href "%BASE_HREF%"
flutter build web --release --base-href "%BASE_HREF%"
if errorlevel 1 (
    echo Error: Web build gagal
    pause
    exit /b 1
)

REM Sync build/web to docs
echo Menyalin build/web -^> docs...
if exist "docs" (
    echo Menghapus folder docs lama...
    rmdir /s /q "docs"
)
mkdir "docs"
xcopy "build\web\*" "docs\" /s /e /y >nul
if errorlevel 1 (
    echo Error: Gagal menyalin file ke docs
    pause
    exit /b 1
)

echo Web build berhasil disalin ke folder docs!

REM Stage changes (docs and latest APK)
echo.
echo Staging perubahan untuk git...
echo -> git add docs
git add docs
if errorlevel 1 (
    echo Error: Git add docs gagal
    pause
    exit /b 1
)

REM Add APK to git if exists
if exist "%APK_DIR%" (
    for %%f in ("%APK_DIR%\*.apk") do (
        echo -> git add "%%f"
        git add "%%f"
        echo Staged APK: %%~nxf
    )
)

REM Get git info for commit message
for /f "tokens=*" %%i in ('git rev-parse --short HEAD') do set SHORT_REV=%%i
for /f "tokens=1-3 delims=/ " %%a in ('date /t') do set CURR_DATE=%%c-%%a-%%b
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set CURR_TIME=%%a:%%b

REM Commit (ignore if nothing to commit)
echo -> git commit -m "build: android apk + web-^>docs (%CURR_DATE% %CURR_TIME%, %SHORT_REV%)"
git commit -m "build: android apk + web->docs (%CURR_DATE% %CURR_TIME%, %SHORT_REV%)"
if errorlevel 1 (
    echo Tidak ada perubahan untuk di-commit atau commit gagal
) else (
    echo Perubahan berhasil di-commit!
)

if "%PUSH_TO_GIT%"=="true" (
    for /f "tokens=*" %%i in ('git rev-parse --abbrev-ref HEAD') do set BRANCH=%%i
    echo Pushing ke origin/!BRANCH!...
    echo -> git push origin !BRANCH!
    git push origin !BRANCH!
    if errorlevel 1 (
        echo Error: Git push gagal
        pause
        exit /b 1
    )
    echo Berhasil push ke GitHub!
) else (
    echo Jalankan dengan parameter --push untuk otomatis push ke GitHub
)

echo.
echo Build selesai!
echo APK tersedia di: android/app/build/outputs/apk/release/
echo Web tersedia di: docs/
echo Setelah push, web akan tersedia di: https://levanza1358.github.io%BASE_HREF%
pause