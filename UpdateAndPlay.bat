@echo off
setlocal
title STS2 Mod Sync (null-1337)

:: --- CONFIGURATION ---
set "REPO_ZIP=https://github.com/null-1337/sts2-mod-sync/archive/refs/heads/main.zip"
:: This points to the default Steam path. 
set "MODS_DIR={YOUR_PATH}\Slay the Spire 2\mods"

echo ===============================================
echo        SLAY THE SPIRE 2 MOD UPDATER
echo ===============================================

:: 1. Clean the folder (Ensures deleted mods are removed)
echo [+] Wiping old mods for a clean sync...
powershell -NoProfile -ExecutionPolicy Bypass -Command "if (Test-Path '%MODS_DIR%') { Remove-Item -Path '%MODS_DIR%\*' -Recurse -Force } else { New-Item -ItemType Directory -Path '%MODS_DIR%' }"

:: 2. Download and Extract
echo [+] Fetching latest mods from GitHub...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$tmp = [System.IO.Path]::GetTempFileName(); Invoke-WebRequest -Uri '%REPO_ZIP%' -OutFile $tmp; Expand-Archive -Path $tmp -DestinationPath $env:TEMP\sts2_extract -Force; $ext = Get-ChildItem -Path $env:TEMP\sts2_extract | Select-Object -First 1; Copy-Item -Path \"$($ext.FullName)\*\" -Destination '%MODS_DIR%' -Recurse -Force; Remove-Item $tmp; Remove-Item $env:TEMP\sts2_extract -Recurse"

echo [+] Sync complete! 
echo ===============================================
exit
