# Keystore Setup Guide - Migrating from Old App

## Finding Your Existing Keystore

### Option 1: Check Common Locations

Look for keystore files in these common locations:

```bash
# Check project directory
find . -name "*.keystore" -o -name "*.jks"

# Check common Android keystore locations
ls ~/.android/*.keystore 2>/dev/null
ls ~/keystore*.jks 2>/dev/null
ls ~/release*.keystore 2>/dev/null
ls ~/app*.jks 2>/dev/null

# Check if you have key.properties already
cat android/key.properties 2>/dev/null
```

### Option 2: If You Have the Keystore File

If you found a `.keystore` or `.jks` file, extract its information:

```bash
# Replace with your actual keystore file path and alias
keytool -list -v -keystore /path/to/your/keystore.jks -alias your-alias-name
```

This will show you:
- SHA1 fingerprint
- SHA256 fingerprint (needed for assetlinks.json)
- Certificate information

**To get the alias name**, you might need to:
- Check old build scripts
- Check old CI/CD configurations
- Try common aliases: `key`, `release`, `upload`, `android`, `kaaikani`

### Option 3: If You Don't Have the Keystore

⚠️ **Important**: If you lost your keystore file, you **cannot** use the same signing key again. You'll need to create a new one, but this means:
- You cannot update the existing app on Play Store (you'll need to publish as a new app)
- Users who have the old app won't be able to update to the new version

## Creating key.properties File

Once you have your keystore file, create `android/key.properties`:

```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=../path/to/your/keystore.jks
```

### Example:

If your keystore is at `/home/rootuser/keystore/kaaikani-release.jks`:

```properties
storePassword=MyStorePassword123
keyPassword=MyKeyPassword123
keyAlias=kaaikani
storeFile=/home/rootuser/keystore/kaaikani-release.jks
```

Or if it's relative to the `android` directory:

```properties
storePassword=MyStorePassword123
keyPassword=MyKeyPassword123
keyAlias=kaaikani
storeFile=../keystore/kaaikani-release.jks
```

## Creating a New Keystore (If You Don't Have One)

If you need to create a new keystore:

```bash
keytool -genkey -v -keystore ~/kaaikani-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias kaaikani
```

This will prompt you for:
- Keystore password
- Key password (can be same as keystore password)
- Your name, organization, etc.

Then create `android/key.properties`:

```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=kaaikani
storeFile=/home/rootuser/kaaikani-release.jks
```

## Security Best Practices

1. **Never commit `key.properties` to Git**
   - It should already be in `.gitignore`
   - Keep it secure and backed up

2. **Use different passwords for store and key** (optional but recommended)

3. **Back up your keystore file** in a secure location
   - If you lose it, you cannot update your app on Play Store

4. **For CI/CD**: Use environment variables instead of storing passwords in files

## Verifying Your Keystore

After creating `key.properties`, verify it works:

```bash
cd android
./gradlew assembleRelease
```

If successful, your signed APK will be at:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Getting SHA256 for assetlinks.json

Once you have your keystore, get the SHA256 fingerprint:

```bash
keytool -list -v -keystore /path/to/your/keystore.jks -alias your-alias-name
```

Look for the `SHA256:` line and add it to `assetlinks.json` (remove colons and spaces).

## Troubleshooting

### "Keystore was tampered with, or password was incorrect"
- Double-check your passwords
- Make sure you're using the correct alias name

### "Cannot recover key"
- The key password might be different from the store password
- Try both passwords

### "Alias does not exist"
- List all aliases: `keytool -list -keystore /path/to/keystore.jks`
- Use the correct alias name

