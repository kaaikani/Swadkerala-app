#!/bin/bash

echo "========================================="
echo "Finding Keystore with Correct SHA1"
echo "========================================="
echo ""
echo "Expected SHA1: FC:DF:E1:8F:73:8E:87:6A:88:00:55:A5:ED:8F:DE:40:E5:8F:79:AD"
echo "Current SHA1:  7B:87:2E:43:7B:68:07:28:A6:D2:7F:BE:28:C2:94:52:58:B7:E1:71"
echo ""
echo "========================================="
echo ""

# List of keystores to check
KEYSTORES=(
    "/home/rootuser/Desktop/test release /sriram(no points)/old2/upload-keystore.jks"
    "/home/rootuser/Desktop/3.1.0/old2/upload-keystore.jks"
    "/home/rootuser/Desktop/localsetup/old2/upload-keystore.jks"
    "/home/rootuser/Desktop/3.1.0/old2/my-upload-key.keystore"
    "/home/rootuser/Desktop/test release /sriram(no points)/old2/my-upload-key.keystore"
)

EXPECTED_SHA1="FC:DF:E1:8F:73:8E:87:6A:88:00:55:A5:ED:8F:DE:40:E5:8F:79:AD"
EXPECTED_SHA1_CLEAN=$(echo "$EXPECTED_SHA1" | tr -d ':')

echo "Checking keystores for matching SHA1..."
echo ""

for keystore in "${KEYSTORES[@]}"; do
    if [ -f "$keystore" ]; then
        echo "Checking: $keystore"
        echo "-----------------------------------"
        
        # Try to get SHA1 without password first (will show warning but might work)
        SHA1_OUTPUT=$(keytool -list -v -keystore "$keystore" -alias upload 2>&1 | grep -i "SHA1:" | head -1)
        
        if [ -n "$SHA1_OUTPUT" ]; then
            SHA1=$(echo "$SHA1_OUTPUT" | sed 's/.*SHA1: *//' | tr -d ' ')
            SHA1_CLEAN=$(echo "$SHA1" | tr -d ':')
            
            echo "Found SHA1: $SHA1"
            
            if [ "$SHA1_CLEAN" = "$EXPECTED_SHA1_CLEAN" ]; then
                echo "✅ MATCH FOUND! This is the correct keystore."
                echo ""
                echo "Keystore path: $keystore"
                echo "Alias: upload"
                echo "SHA1: $SHA1"
                echo ""
                echo "Next step: Create android/key.properties with this keystore path"
                exit 0
            else
                echo "❌ SHA1 does not match"
            fi
        else
            echo "⚠️  Could not read SHA1 (password required or alias not found)"
            echo "   Try running manually:"
            echo "   keytool -list -v -keystore \"$keystore\" -alias upload"
        fi
        echo ""
    fi
done

echo "========================================="
echo "Manual Check Required"
echo "========================================="
echo ""
echo "If no match was found automatically, check each keystore manually:"
echo ""
for keystore in "${KEYSTORES[@]}"; do
    if [ -f "$keystore" ]; then
        echo "keytool -list -v -keystore \"$keystore\" -alias upload"
    fi
done
echo ""
echo "Look for SHA1: $EXPECTED_SHA1"
echo ""

