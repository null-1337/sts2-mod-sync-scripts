#!/bin/bash

# --- CONFIGURATION ---
REPO_ZIP="https://github.com/null-1337/sts2-mod-sync/archive/refs/heads/main.zip"
# Standard Steam Deck / Linux path
MODS_DIR="$HOME/.steam/steam/steamapps/common/Slay the Spire 2/mods"

echo "-----------------------------------------------"
echo "    STS2 MOD SYNC - LINUX (null-1337)"
echo "-----------------------------------------------"

# 1. Create directory if missing and clean it
mkdir -p "$MODS_DIR"
echo "[+] Cleaning old mods..."
rm -rf "$MODS_DIR"/*

# 2. Download and Extract
echo "[+] Downloading from GitHub..."
TMP_ZIP=$(mktemp)
TMP_DIR=$(mktemp -d)

curl -L "$REPO_ZIP" -o "$TMP_ZIP"
unzip -q "$TMP_ZIP" -d "$TMP_DIR"

# 3. Move contents (Skips the RepoName-main wrapper folder)
EXTRACTED_SUBDIR=$(ls -d "$TMP_DIR"/*/)
cp -r "$EXTRACTED_SUBDIR"* "$MODS_DIR"

# 4. Cleanup
rm "$TMP_ZIP"
rm -rf "$TMP_DIR"

echo "[+] Sync complete!"
