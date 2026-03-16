#!/bin/bash

# --- CONFIGURATION ---
# Ensure this matches the URL that worked in your .bat file
REPO_URL="https://github.com/null-1337/sts2-mod-sync/archive/refs/heads/master.zip"

# Get the directory where THIS script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MODS_DIR="$SCRIPT_DIR/mods"

echo "-----------------------------------------------"
echo "    STS2 MOD SYNC - LINUX (null-1337)"
echo "-----------------------------------------------"

# 1. LOCATION & SAFETY CHECK
# Check for the executable (handling potential case sensitivity in Linux)
if [[ ! -f "$SCRIPT_DIR/SlayTheSpire2.exe" && ! -f "$SCRIPT_DIR/Slay the Spire 2.exe" && ! -f "$SCRIPT_DIR/SlayTheSpire2" ]]; then
    echo "[ERROR] Script must be in the Slay the Spire 2 game folder."
    echo "Current Location: $SCRIPT_DIR"
    exit 1
fi

# 2. DOWNLOAD
echo "[+] Downloading latest mods..."
# -f fails on 404, -L follows redirects, -A is User Agent
if ! curl -f -L -A "Mozilla/5.0" -o "mods_temp.zip" "$REPO_URL"; then
    echo "[ERROR] Download failed! Check if repo is Public and URL is correct."
    rm -f mods_temp.zip
    exit 1
fi

# 3. EXTRACT
echo "[+] Extracting files..."
rm -rf "temp_extract"
mkdir -p "temp_extract"

if ! unzip -q "mods_temp.zip" -d "temp_extract"; then
    echo "[ERROR] Extraction failed! The download might be corrupted."
    exit 1
fi

# 4. CLEAN AND SYNC
echo "[+] Cleaning and Syncing mods folder..."
# Strict safety check before deleting: ensure the path contains the game name
if [[ "$MODS_DIR" == *"Slay the Spire 2/mods"* ]]; then
    rm -rf "$MODS_DIR"
    mkdir -p "$MODS_DIR"
    
    # Move contents from the GitHub wrapper folder (e.g., sts2-mod-sync-main/*)
    # This finds the first subdirectory in temp_extract and moves its contents
    EXTRACTED_SUBDIR=$(find temp_extract -maxdepth 1 -mindepth 1 -type d | head -n 1)
    cp -r "$EXTRACTED_SUBDIR"/* "$MODS_DIR/"
else
    echo "[ERROR] Safety Check Failed: MODS_DIR path looks suspicious."
    exit 1
fi

# 5. CLEANUP
echo "[+] Finalizing..."
rm "mods_temp.zip"
rm -rf "temp_extract"

echo "-----------------------------------------------"
echo "   SUCCESS! You can now close this window
echo "-----------------------------------------------"
