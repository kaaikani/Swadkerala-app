#!/bin/bash

# Script to create Android notification icons from app logo
# This script creates white/transparent notification icons in multiple densities

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Creating Android Notification Icons${NC}"
echo "=================================="

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo -e "${RED}Error: ImageMagick is not installed${NC}"
    echo "Install it with:"
    echo "  Linux: sudo apt-get install imagemagick"
    echo "  macOS: brew install imagemagick"
    exit 1
fi

# Check if source logo exists
if [ ! -f "assets/images/kklogo.png" ]; then
    echo -e "${RED}Error: assets/images/kklogo.png not found${NC}"
    exit 1
fi

# Create drawable directories if they don't exist
mkdir -p android/app/src/main/res/drawable-mdpi
mkdir -p android/app/src/main/res/drawable-hdpi
mkdir -p android/app/src/main/res/drawable-xhdpi
mkdir -p android/app/src/main/res/drawable-xxhdpi
mkdir -p android/app/src/main/res/drawable-xxxhdpi

echo -e "${YELLOW}Step 1: Converting logo to white/transparent version...${NC}"
# Create a temporary white version of the logo
# This converts the logo to grayscale, then to white with transparency
convert assets/images/kklogo.png \
    -colorspace Gray \
    -negate \
    -alpha on \
    -channel A -evaluate multiply 0.9 +channel \
    -background transparent \
    temp_white_logo.png

echo -e "${YELLOW}Step 2: Creating small notification icons (white/transparent)...${NC}"

# Small icons (white/transparent) for notification tray
# mdpi: 24x24
convert temp_white_logo.png \
    -resize 24x24 \
    -background transparent \
    -gravity center \
    -extent 24x24 \
    android/app/src/main/res/drawable-mdpi/notification_icon.png
echo "✓ Created drawable-mdpi/notification_icon.png (24x24)"

# hdpi: 36x36
convert temp_white_logo.png \
    -resize 36x36 \
    -background transparent \
    -gravity center \
    -extent 36x36 \
    android/app/src/main/res/drawable-hdpi/notification_icon.png
echo "✓ Created drawable-hdpi/notification_icon.png (36x36)"

# xhdpi: 48x48
convert temp_white_logo.png \
    -resize 48x48 \
    -background transparent \
    -gravity center \
    -extent 48x48 \
    android/app/src/main/res/drawable-xhdpi/notification_icon.png
echo "✓ Created drawable-xhdpi/notification_icon.png (48x48)"

# xxhdpi: 72x72
convert temp_white_logo.png \
    -resize 72x72 \
    -background transparent \
    -gravity center \
    -extent 72x72 \
    android/app/src/main/res/drawable-xxhdpi/notification_icon.png
echo "✓ Created drawable-xxhdpi/notification_icon.png (72x72)"

# xxxhdpi: 96x96
convert temp_white_logo.png \
    -resize 96x96 \
    -background transparent \
    -gravity center \
    -extent 96x96 \
    android/app/src/main/res/drawable-xxxhdpi/notification_icon.png
echo "✓ Created drawable-xxxhdpi/notification_icon.png (96x96)"

echo ""
echo -e "${YELLOW}Step 3: Creating large notification icons (colored with green background)...${NC}"

# Large icons (colored with green background) for expanded notifications
# mdpi: 64x64
convert assets/images/kklogo.png \
    -resize 64x64 \
    -background "#22A45D" \
    -gravity center \
    -extent 64x64 \
    android/app/src/main/res/drawable-mdpi/notification_large_icon.png
echo "✓ Created drawable-mdpi/notification_large_icon.png (64x64)"

# hdpi: 96x96
convert assets/images/kklogo.png \
    -resize 96x96 \
    -background "#22A45D" \
    -gravity center \
    -extent 96x96 \
    android/app/src/main/res/drawable-hdpi/notification_large_icon.png
echo "✓ Created drawable-hdpi/notification_large_icon.png (96x96)"

# xhdpi: 128x128
convert assets/images/kklogo.png \
    -resize 128x128 \
    -background "#22A45D" \
    -gravity center \
    -extent 128x128 \
    android/app/src/main/res/drawable-xhdpi/notification_large_icon.png
echo "✓ Created drawable-xhdpi/notification_large_icon.png (128x128)"

# xxhdpi: 192x192
convert assets/images/kklogo.png \
    -resize 192x192 \
    -background "#22A45D" \
    -gravity center \
    -extent 192x192 \
    android/app/src/main/res/drawable-xxhdpi/notification_large_icon.png
echo "✓ Created drawable-xxhdpi/notification_large_icon.png (192x192)"

# xxxhdpi: 256x256
convert assets/images/kklogo.png \
    -resize 256x256 \
    -background "#22A45D" \
    -gravity center \
    -extent 256x256 \
    android/app/src/main/res/drawable-xxxhdpi/notification_large_icon.png
echo "✓ Created drawable-xxxhdpi/notification_large_icon.png (256x256)"

# Clean up temporary file
rm -f temp_white_logo.png

echo ""
echo -e "${GREEN}✅ Notification icons created successfully!${NC}"
echo ""
echo "Note: Android will automatically apply the system accent color (green) as background"
echo "The icons are white/transparent and will appear with green background in notifications"
echo ""
echo "Next steps:"
echo "1. Rebuild the app: flutter build apk"
echo "2. Test notifications from Firebase Console"
echo "3. Check notification tray to see your custom icon"

