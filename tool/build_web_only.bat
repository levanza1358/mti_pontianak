@echo off
setlocal enabledelayedexpansion

echo == MTI Pontianak: Build Web to docs (Manual Git) ==

REM Default parameters
set BASE_HREF=/mti_pontianak/
set CLEAN_BUILD=false

REM Parse command line arguments
:parse_args
if "%1"=="" goto start_build
if "%1"=="--clean" set CLEAN_BUILD=true
if "%1"=="-clean" set CLEAN_BUILD=true
if "%1"=="/clean" set CLEAN_BUILD=true
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

REM Build Web (release) with base href
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

echo.
echo Web build selesai!
echo File web tersedia di folder: docs/
echo Setelah push manual, akan tersedia di: https://levanza1358.github.io%BASE_HREF%
echo.
echo CATATAN: Script ini TIDAK melakukan commit/push otomatis.
echo Anda bisa melakukan git add, commit, dan push secara manual.
pause