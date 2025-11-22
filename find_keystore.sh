#!/bin/bash

echo "========================================="
echo "Keystore Finder - For Old App Migration"
echo "========================================="
echo ""

# Search for keystore files
echo "1. Searching for keystore files..."
echo "-----------------------------------"
find ~ -name "*.keystore" -o -name "*.jks" 2>/dev/null | head -20
echo ""

# Check common locations
echo "2. Checking common Android keystore locations..."
echo "-----------------------------------"
for path in \
  "$HOME/.android/debug.keystore" \
  "$HOME/.android/release.keystore" \
  "$HOME/keystore.jks" \
  "$HOME/release.keystore" \
  "$HOME/app-release.jks" \
  "$HOME/kaaikani*.jks" \
  "$HOME/kaaikani*.keystore" \
  "./android/*.jks" \
  "./android/*.keystore" \
  "./*.jks" \
  "./*.keystore"
do
  if [ -f "$path" ]; then
    echo "Found: $path"
    ls -lh "$path"
  fi
done
echo ""

# Check for key.properties
echo "3. Checking for existing key.properties..."
echo "-----------------------------------"
if [ -f "android/key.properties" ]; then
  echo "Found android/key.properties:"
  cat android/key.properties
else
  echo "No key.properties found"
fi
echo ""

# Check for old APK to extract package info
echo "4. Searching for old APK files (to verify package name)..."
echo "-----------------------------------"
find ~ -name "*.apk" -type f 2>/dev/null | grep -i "kaaikani\|unified\|ecom" | head -5
echo ""

# Instructions
echo "========================================="
echo "Next Steps:"
echo "========================================="
echo ""
echo "If you found a keystore file, extract its info:"
echo "  keytool -list -v -keystore /path/to/keystore.jks -alias ALIAS_NAME"
echo ""
echo "To find the alias name, try:"
echo "  keytool -list -keystore /path/to/keystore.jks"
echo ""
echo "Common alias names to try:"
echo "  - key"
echo "  - release"
echo "  - upload"
echo "  - android"
echo "  - kaaikani"
echo "  - unified"
echo ""












