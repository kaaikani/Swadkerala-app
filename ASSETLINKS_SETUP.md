# Android App Links - assetlinks.json Setup

## File Location

You need to host the `assetlinks.json` file on your web server at:

```
https://kaaikani.co.in/.well-known/assetlinks.json
```

## File Content

The file content is already created in `assetlinks.json` in your project root. Copy this file to your web server.

## Current Configuration

- **Package Name**: `com.kaaikani.kaaikani`
- **SHA256 Fingerprint (Debug)**: `D1F5FD9D2BE06B77B284A70F07001AEF9B92AF46C572445A5CC638159C82BD39`

## Steps to Deploy

### 1. Copy the file to your web server

Upload `assetlinks.json` to:
```
https://kaaikani.co.in/.well-known/assetlinks.json
```

### 2. Verify the file is accessible

Test that the file is accessible:
```bash
curl https://kaaikani.co.in/.well-known/assetlinks.json
```

### 3. Important Requirements

- ✅ File must be served over **HTTPS** (not HTTP)
- ✅ File must return `Content-Type: application/json` header
- ✅ File must be accessible without redirects
- ✅ File must be valid JSON

### 4. Server Configuration Example

#### For Apache (.htaccess):
```apache
<IfModule mod_headers.c>
    <FilesMatch "\.well-known/assetlinks\.json$">
        Header set Content-Type "application/json"
    </FilesMatch>
</IfModule>
```

#### For Nginx:
```nginx
location /.well-known/assetlinks.json {
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
}
```

## For Production Release

When you build a **release APK/AAB**, you'll need to:

1. **Get the release keystore SHA256 fingerprint:**
   ```bash
   keytool -list -v -keystore /path/to/your/release.keystore -alias your-key-alias
   ```

2. **Add it to assetlinks.json:**
   ```json
   [
     {
       "relation": ["delegate_permission/common.handle_all_urls"],
       "target": {
         "namespace": "android_app",
         "package_name": "com.kaaikani.kaaikani",
         "sha256_cert_fingerprints": [
           "DEBUG_SHA256_FINGERPRINT",
           "RELEASE_SHA256_FINGERPRINT"
         ]
       }
     }
   ]
   ```

3. **Update the file on your web server**

## Verify Setup

Use Google's Digital Asset Links API to verify:

```bash
curl "https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://kaaikani.co.in&relation=delegate_permission/common.handle_all_urls"
```

Or use the online tool:
https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://kaaikani.co.in&relation=delegate_permission/common.handle_all_urls

## Testing

After deploying, test with:
```bash
adb shell am start -W -a android.intent.action.VIEW -d "https://kaaikani.co.in/product?id=123" com.kaaikani.kaaikani
```

The app should open directly without showing the "Open with" dialog.

