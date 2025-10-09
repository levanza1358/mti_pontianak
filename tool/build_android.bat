@echo off
setlocal enabledelayedexpansion

echo == MTI Pontianak: Build Android APK ==

REM Check for clean parameter
set CLEAN_BUILD=false
if "%1"=="--clean" set CLEAN_BUILD=true
if "%1"=="-clean" set CLEAN_BUILD=true
if "%1"=="/clean" set CLEAN_BUILD=true

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

REM Build Android APK (release)
echo Building Android APK (release)...
echo -> flutter build apk --release
flutter build apk --release
if errorlevel 1 (
    echo Error: Android build gagal
    pause
    exit /b 1
)

REM Show APK location
set APK_DIR=android\app\build\outputs\apk\release
if exist "%APK_DIR%" (
    for %%f in ("%APK_DIR%\*.apk") do (
        echo APK berhasil dibuat: %%f
        for %%a in ("%%f") do (
            set /a size_mb=%%~za/1024/1024
            echo   Ukuran: !size_mb! MB
        )
    )
) else (
    echo Warning: APK directory tidak ditemukan
)

echo.
echo Android build selesai!
pause