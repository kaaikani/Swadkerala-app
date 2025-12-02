#!/bin/bash

echo "========================================="
echo "Keystore Information Extractor"
echo "========================================="
echo ""

KEYSTORE_DIR="/home/rootuser/Desktop/test release /old2"

# Check if directory exists
if [ ! -d "$KEYSTORE_DIR" ]; then
    echo "Error: Directory not found: $KEYSTORE_DIR"
    echo "Please update KEYSTORE_DIR in this script with the correct path"
    exit 1
fi

echo "Found keystore files:"
echo "-----------------------------------"
ls -lh "$KEYSTORE_DIR"/*.keystore "$KEYSTORE_DIR"/*.jks 2>/dev/null
echo ""

# Try to list aliases from each keystore
for keystore in "$KEYSTORE_DIR"/*.keystore "$KEYSTORE_DIR"/*.jks; do
    if [ -f "$keystore" ]; then
        echo "========================================="
        echo "Keystore: $(basename "$keystore")"
        echo "========================================="
        echo ""
        echo "To list aliases in this keystore, run:"
        echo "  keytool -list -keystore \"$keystore\""
        echo ""
        echo "To get detailed info (including SHA256), run:"
        echo "  keytool -list -v -keystore \"$keystore\" -alias ALIAS_NAME"
        echo ""
        echo "Common alias names to try:"
        echo "  - upload"
        echo "  - key"
        echo "  - release"
        echo "  - android"
        echo "  - kaaikani"
        echo ""
    fi
done

echo "========================================="
echo "Next Steps:"
echo "========================================="
echo ""
echo "1. Find the alias name:"
echo "   keytool -list -keystore \"$KEYSTORE_DIR/upload-keystore.jks\""
echo ""
echo "2. Get SHA256 fingerprint:"
echo "   keytool -list -v -keystore \"$KEYSTORE_DIR/upload-keystore.jks\" -alias YOUR_ALIAS"
echo ""
echo "3. Create android/key.properties with the information"
echo ""













