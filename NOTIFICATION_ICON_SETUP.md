# Notification Icon Setup Guide

## Overview
The app uses a custom notification icon (`notification_icon`) with a green background for push notifications. This icon is displayed in the notification tray when notifications arrive.

## Current Configuration

- **Notification Icon**: `@drawable/notification_icon`
- **App Logo**: `assets/images/kklogo.png` (used in splash screen with green background)
- **Background Color**: Green

## Creating Notification Icons

### Android Notification Icon Requirements

Android notification icons must be:
- **White/Transparent** on a **transparent background** (Android will apply the system accent color)
- **24x24dp** base size (but provide multiple densities)
- **Simple and recognizable** (avoid fine details)

### Steps to Create Notification Icon

1. **Take your logo** (`assets/images/kklogo.png`)

2. **Convert to white/transparent version**:
   - Open the logo in an image editor
   - Convert to white/transparent (remove colors, make it white)
   - Ensure background is transparent
   - Save as PNG with transparency

3. **Create multiple densities**:
   - **mdpi**: 24x24 pixels
   - **hdpi**: 36x36 pixels
   - **xhdpi**: 48x48 pixels
   - **xxhdpi**: 72x72 pixels
   - **xxxhdpi**: 96x96 pixels

4. **Place icons in Android drawable folders**:
   ```
   android/app/src/main/res/
   ├── drawable-mdpi/
   │   ├── notification_icon.png (24x24) - Small icon (white/transparent)
   │   └── notification_large_icon.png (64x64) - Large icon (colored with green background)
   ├── drawable-hdpi/
   │   ├── notification_icon.png (36x36)
   │   └── notification_large_icon.png (96x96)
   ├── drawable-xhdpi/
   │   ├── notification_icon.png (48x48)
   │   └── notification_large_icon.png (128x128)
   ├── drawable-xxhdpi/
   │   ├── notification_icon.png (72x72)
   │   └── notification_large_icon.png (192x192)
   └── drawable-xxxhdpi/
       ├── notification_icon.png (96x96)
       └── notification_large_icon.png (256x256)
   ```

   **Note**: 
   - `notification_icon` = Small icon (white/transparent) for notification tray
   - `notification_large_icon` = Large icon (colored logo with green background) for expanded notification

### Alternative: Use Android Asset Studio

1. Go to: https://romannurik.github.io/AndroidAssetStudio/icons-notification.html
2. Upload your logo image
3. Select "Notification Icons"
4. Adjust settings:
   - **Foreground**: Your logo (white/transparent)
   - **Background**: Green color (#4CAF50 or your brand green)
   - **Padding**: 20-30%
5. Download the generated icons
6. Extract and place in the drawable folders above

### Quick Setup Script

You can also use a script to generate icons from your asset:

```bash
# Install ImageMagick if not installed
# sudo apt-get install imagemagick  # Linux
# brew install imagemagick          # macOS

# Create notification icon from asset logo
convert assets/images/kklogo.png -resize 24x24 -background transparent -gravity center -extent 24x24 android/app/src/main/res/drawable-mdpi/notification_icon.png
convert assets/images/kklogo.png -resize 36x36 -background transparent -gravity center -extent 36x36 android/app/src/main/res/drawable-hdpi/notification_icon.png
convert assets/images/kklogo.png -resize 48x48 -background transparent -gravity center -extent 48x48 android/app/src/main/res/drawable-xhdpi/notification_icon.png
convert assets/images/kklogo.png -resize 72x72 -background transparent -gravity center -extent 72x72 android/app/src/main/res/drawable-xxhdpi/notification_icon.png
convert assets/images/kklogo.png -resize 96x96 -background transparent -gravity center -extent 96x96 android/app/src/main/res/drawable-xxxhdpi/notification_icon.png
```

**Note**: Make sure the logo is converted to white/transparent first, as Android notification icons should be monochrome.

## Verification

After creating the icons:

1. **Build the app**: `flutter build apk` or `flutter run`
2. **Send a test notification** from Firebase Console
3. **Check notification tray** - you should see your custom icon with green background

## Fallback

If `notification_icon` is not found, the app will fallback to `@mipmap/ic_launcher`. However, it's recommended to create the custom notification icon for better branding.

## App Logo Usage

The app logo (`assets/images/kklogo.png`) is used in:
- **Splash Screen**: Displayed with green background
- **Notification Icon**: Converted to white/transparent version for notifications

## Color Reference

- **Green Background**: Use your brand green color (e.g., `Colors.green` or `Color(0xFF4CAF50)`)
- **Logo**: White/transparent version for notifications

