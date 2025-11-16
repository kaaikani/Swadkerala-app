# Keystore Setup - Complete Guide

## ✅ Found Your Keystore Files

- **Location**: `/home/rootuser/Desktop/test release /old2/`
- **Files**:
  - `upload-keystore.jks` (recommended - 2.6KB)
  - `my-upload-key.keystore` (2.7KB)
- **Alias**: `upload` (confirmed)

## Step 1: Create key.properties File

1. Copy the template:
   ```bash
   cp android/key.properties.template android/key.properties
   ```

2. Edit `android/key.properties` and fill in your passwords:
   ```properties
   storeFile=/home/rootuser/Desktop/test release /old2/upload-keystore.jks
   storePassword=YOUR_ACTUAL_KEYSTORE_PASSWORD
   keyAlias=upload
   keyPassword=YOUR_ACTUAL_KEY_PASSWORD
   ```

   **Note**: Replace `YOUR_ACTUAL_KEYSTORE_PASSWORD` and `YOUR_ACTUAL_KEY_PASSWORD` with your real passwords.

## Step 2: Get SHA256 Fingerprint for assetlinks.json

Run this command (you'll be prompted for the keystore password):

```bash
keytool -list -v -keystore "/home/rootuser/Desktop/test release /old2/upload-keystore.jks" -alias upload
```

Look for the `SHA256:` line. Copy it and:
1. Remove all colons (`:`) and spaces
2. Convert to lowercase
3. Add it to `assetlinks.json` in the `sha256_cert_fingerprints` array

Example:
```
SHA256: D1:F5:FD:9D:2B:E0:6B:77:B2:84:A7:0F:07:00:1A:EF:9B:92:AF:46:C5:72:44:5A:5C:C6:38:15:9C:82:BD:39
```

Becomes:
```
D1F5FD9D2BE06B77B284A70F07001AEF9B92AF46C572445A5CC638159C82BD39
```

## Step 3: Verify Setup

After creating `key.properties`, test the build:

```bash
flutter clean
flutter build apk --release
```

If successful, your signed APK will be at:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Step 4: Build App Bundle (Recommended for Play Store)

For Google Play Store, build an App Bundle instead:

```bash
flutter build appbundle --release
```

This creates:
```
build/app/outputs/bundle/release/app-release.aab
```

Upload the `.aab` file to Play Store (not the `.apk`).

## Security Reminders

✅ **DO NOT** commit `android/key.properties` to Git
- It should be in `.gitignore` (already configured)
- Keep it secure and backed up

✅ **Back up your keystore file**
- If you lose it, you cannot update your app on Play Store
- Store it in a secure location

## APK Size Optimization

Your current APK is **63.4MB**. I've enabled optimizations:

✅ **Minification enabled** - Reduces code size
✅ **Resource shrinking enabled** - Removes unused resources
✅ **ProGuard rules created** - Keeps necessary classes

**Expected new size**: 35-45MB (30-40% reduction)

Rebuild to see the new size:
```bash
flutter clean
flutter build apk --release
```

## Troubleshooting

### "Keystore was tampered with, or password was incorrect"
- Double-check your passwords in `key.properties`
- Make sure there are no extra spaces

### "Cannot recover key"
- The key password might be different from the store password
- Try both passwords

### Build fails with ProGuard errors
- Check `android/app/proguard-rules.pro`
- You may need to add more `-keep` rules for specific classes

## Next Steps

1. ✅ Create `android/key.properties` with your passwords
2. ✅ Get SHA256 fingerprint and update `assetlinks.json`
3. ✅ Rebuild APK to verify signing works
4. ✅ Check new APK size (should be smaller)
5. ✅ Build AAB for Play Store upload

