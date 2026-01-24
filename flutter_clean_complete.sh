#!/bin/bash

# Complete Flutter clean script that also removes generated splash screen files
# Usage: ./flutter_clean_complete.sh

echo "=========================================="
echo "Complete Flutter Clean"
echo "=========================================="
echo ""

# Run standard flutter clean
echo "Step 1: Running flutter clean..."
flutter clean
echo ""

# Run splash screen cleanup
echo "Step 2: Cleaning generated splash screen files..."
if [ -f "./clean_splash.sh" ]; then
    bash ./clean_splash.sh
else
    echo "  ⚠ clean_splash.sh not found, skipping splash cleanup"
fi
echo ""

echo "=========================================="
echo "Clean complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Run: flutter pub get"
echo "  2. Run: dart run flutter_native_splash:create (to regenerate splash)"
echo "  3. Run: dart run flutter_launcher_icons (to regenerate icons)"

