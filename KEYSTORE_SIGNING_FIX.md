# Fix: App Bundle Signed with Wrong Key

## Problem
Your Android App Bundle is signed with the wrong key. Google Play Store expects:
- **Expected SHA1**: `FC:DF:E1:8F:73:8E:87:6A:88:00:55:A5:ED:8F:DE:40:E5:8F:79:AD`
- **Current SHA1**: `7B:87:2E:43:7B:68:07:28:A6:D2:7F:BE:28:C2:94:52:58:B7:E1:71`

## Solution Steps

### Step 1: Find the Correct Keystore

You need to find the keystore file that has the SHA1 fingerprint matching the expected one.

**Potential keystore locations**:
1. `/home/rootuser/Desktop/test release /sriram(no points)/old2/upload-keystore.jks`
2. `/home/rootuser/Desktop/3.1.0/old2/upload-keystore.jks`
3. `/home/rootuser/Desktop/localsetup/old2/upload-keystore.jks`
4. `/home/rootuser/Desktop/3.1.0/old2/my-upload-key.keystore`
5. `/home/rootuser/Desktop/test release /sriram(no points)/old2/my-upload-key.keystore`

### Step 2: Check Each Keystore's SHA1

Run this command for each keystore (you'll need the keystore password):

```bash
keytool -list -v -keystore "/path/to/keystore.jks" -alias upload
```

**Look for this line in the output**:
```
SHA1: FC:DF:E1:8F:73:8E:87:6A:88:00:55:A5:ED:8F:DE:40:E5:8F:79:AD
```

If the SHA1 matches, that's your correct keystore!

### Step 3: Create key.properties File

Once you find the correct keystore, create `android/key.properties`:

```properties
storeFile=/absolute/path/to/upload-keystore.jks
storePassword=YOUR_KEYSTORE_PASSWORD
keyAlias=upload
keyPassword=YOUR_KEY_PASSWORD
```

**Example** (if keystore is at `/home/rootuser/Desktop/3.1.0/old2/upload-keystore.jks`):
```properties
storeFile=/home/rootuser/Desktop/3.1.0/old2/upload-keystore.jks
storePassword=your_keystore_password_here
keyAlias=upload
keyPassword=your_key_password_here
```

### Step 4: Rebuild App Bundle

After creating `key.properties`, rebuild the app bundle:

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

The new bundle will be signed with the correct keystore.

## Quick Check Commands

**Check if key.properties exists**:
```bash
ls -la android/key.properties
```

**List aliases in a keystore** (to find the alias name):
```bash
keytool -list -keystore "/path/to/keystore.jks"
```

**Get SHA1 fingerprint**:
```bash
keytool -list -v -keystore "/path/to/keystore.jks" -alias upload | grep SHA1
```

## Important Notes

⚠️ **Security**:
- Never commit `key.properties` to version control
- Keep your keystore file secure and backed up
- Store passwords securely

⚠️ **If You Lost the Keystore**:
- You cannot update the app on Play Store with a different keystore
- Contact Google Play Support if you've lost the original keystore
- Consider using Google Play App Signing for future protection

## File Locations

- **Keystore Config**: `android/key.properties` (create this file)
- **Build Config**: `android/app/build.gradle.kts` (already configured)
- **Template**: `android/key.properties.template` (reference only)

