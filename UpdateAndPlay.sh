#!/bin/bash

# --- CONFIGURATION ---
REPO_URL="https://github.com/null-1337/sts2-mod-sync/archive/refs/heads/master.zip"

# Get the directory where THIS script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MODS_DIR="$SCRIPT_DIR/mods"

echo "-----------------------------------------------"
echo "      STS2 MOD SYNC - LINUX (null-1337)"
echo "-----------------------------------------------"

# 1. LOCATION & SAFETY CHECK
# Checking for common binary names in Linux and Windows versions
if [[ ! -f "$SCRIPT_DIR/SlayTheSpire2" && ! -f "$SCRIPT_DIR/SlayTheSpire2.exe" && ! -d "$SCRIPT_DIR/Slay the Spire 2" ]]; then
    echo "[ERROR] Script must be in the Slay the Spire 2 game folder."
    echo "Current Location: $SCRIPT_DIR"
    exit 1
fi

# 2. DOWNLOAD
echo "[+] Downloading latest mods..."
if ! curl -f -L -A "Mozilla/5.0" -o "mods_temp.zip" "$REPO_URL"; then
    echo "[ERROR] Download failed! Check if repo is Public and URL is correct."
    rm -f "mods_temp.zip"
    exit 1
fi

# 3. EXTRACT
echo "[+] Extracting files..."
rm -rf "temp_extract"
mkdir -p "temp_extract"

if ! unzip -q "mods_temp.zip" -d "temp_extract"; then
    echo "[ERROR] Extraction failed! The download might be corrupted."
    rm -f "mods_temp.zip"
    exit 1
fi

# 4. CLEAN AND SYNC
echo "[+] Cleaning and Syncing mods folder..."

# We use a case-insensitive check for the directory name to be safe
FOLDER_NAME=$(basename "$SCRIPT_DIR" | tr '[:upper:]' '[:lower:]')

if [[ "$FOLDER_NAME" == *"slay the spire 2"* || "$FOLDER_NAME" == *"sts2"* ]]; then
    # Ensure mods directory exists
    mkdir -p "$MODS_DIR"
    
    # Wipe existing mods to ensure a clean sync
    rm -rf "$MODS_DIR"/*
    
    # Find the extracted subdirectory (GitHub adds a branch name suffix like -master or -main)
    EXTRACTED_SUBDIR=$(find temp_extract -maxdepth 1 -mindepth 1 -type d | head -n 1)
    
    if [ -n "$EXTRACTED_SUBDIR" ]; then
        cp -r "$EXTRACTED_SUBDIR"/* "$MODS_DIR/"
        echo "[+] Mods successfully moved to: $MODS_DIR"
    else
        echo "[ERROR] Could not find extracted content in temp_extract."
        exit 1
    fi
else
    echo "[ERROR] Safety Check Failed: Folder '$FOLDER_NAME' doesn't look like an StS2 directory."
    exit 1
fi

# 5. CLEANUP
echo "[+] Finalizing..."
rm -f "mods_temp.zip"
rm -rf "temp_extract"

echo "-----------------------------------------------"
echo "   SUCCESS! You can now close this window."
echo "-----------------------------------------------"
