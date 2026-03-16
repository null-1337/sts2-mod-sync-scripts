@echo off
title STS2 Mod Sync - FORCE PAUSE MODE

:: --- CONFIGURATION ---
set "REPO_URL=https://github.com/null-1337/sts2-mod-sync/archive/refs/heads/master.zip"
set "MODS_DIR=%~dp0mods"

echo Current Folder: %~dp0
echo Target Folder: %MODS_DIR%
echo.

:: 1. DOWNLOAD
echo [+] Downloading...
curl -f -L -A "Mozilla/5.0" -o "mods_temp.zip" "%REPO_URL%"
if %errorlevel% neq 0 (
    echo [!] DOWNLOAD FAILED. Error Code: %errorlevel%
    pause
    exit /b
)

:: 2. EXTRACT
echo [+] Extracting...
if exist "temp_extract" rd /s /q "temp_extract"
mkdir "temp_extract"
tar -xf "mods_temp.zip" -C "temp_extract"
if %errorlevel% neq 0 (
    echo [!] EXTRACTION FAILED. The file might not be a valid zip.
    pause
    exit /b
)

:: 3. SYNC
echo [+] Syncing...
if exist "%MODS_DIR%" rd /s /q "%MODS_DIR%"
mkdir "%MODS_DIR%"
for /d %%i in ("temp_extract\*") do (
    xcopy /e /y /q "%%i\*" "%MODS_DIR%\"
)

:: 4. CLEANUP
echo [+] Cleaning up temp files...
del /q "mods_temp.zip"
rd /s /q "temp_extract"

echo.
echo ===============================================
echo   SUCCESS!
echo ===============================================

echo.
echo Script finished. Press any key to close.
pause
