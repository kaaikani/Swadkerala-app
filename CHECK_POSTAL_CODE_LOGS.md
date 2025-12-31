# How to Check Postal Code Fetch Logs

## Method 1: Using Flutter Logs (Recommended)

1. **Run the app:**
   ```bash
   flutter run
   ```

2. **In a separate terminal, run:**
   ```bash
   flutter logs | grep -i "postal\|Customer.*FETCH\|AddressComponent.*FETCH"
   ```

3. **Or view all logs:**
   ```bash
   flutter logs
   ```

## Method 2: Using Android Logcat

```bash
adb logcat -s flutter:* | grep -i "postal\|Customer.*FETCH"
```

## Method 3: View Logs in IDE

- **VS Code**: Check the Debug Console or Output panel
- **Android Studio**: Check the Logcat window
- Filter by: `postal` or `Customer` or `AddressComponent`

## What to Look For:

When you click **"Add Address"** or **"Edit Address"**, you should see these logs:

### 1. Address Component Logs:
```
[AddressComponent] ========== ADDRESS FORM DIALOG OPENED ==========
[AddressComponent] ========== DIALOG BUILDER CALLED ==========
[AddressComponent] ========== FETCHING POSTAL CODES ==========
[AddressComponent] Calling customerController.fetchPostalCodes()...
```

### 2. Customer Controller Logs:
```
═══════════════════════════════════════════════════════════
[Customer] ========== FETCHING POSTAL CODES ==========
[Customer] Function called at: [timestamp]
[Customer] ──── CHANNEL TOKEN CHECK ────
[Customer] Current channel token from GraphQLService: ...
[Customer] Current channel token from storage: ...
[Customer] Channel code from storage: ...
[Customer] ──── EXECUTING GRAPHQL QUERY ────
[Customer] ──── GRAPHQL RESPONSE RECEIVED ────
[Customer] ──── RAW RESPONSE DATA ────
[Customer] ──── PARSING RESPONSE ────
[Customer] ========== POSTAL CODES RESULT ==========
[Customer] Found X postal codes
[Customer] Channel used: [channel_token]
```

### 3. Success Logs:
```
[AddressComponent] ========== POSTAL CODES FETCH COMPLETED ==========
[AddressComponent] Received X postal codes
```

### 4. Error Logs (if any):
```
[Customer] ⚠️⚠️⚠️ WARNING: Channel token is empty!
[Customer] ═══════════════════════════════════════════════════════════
[Customer] ========== GRAPHQL EXCEPTION ==========
[AddressComponent] ========== POSTAL CODES FETCH ERROR ==========
```

## Troubleshooting:

1. **If no logs appear:**
   - Make sure the app is running
   - Click "Add Address" or "Edit Address" button
   - Check if logs are being filtered out

2. **If channel token is empty:**
   - Check that channel was set during login/home page load
   - Look for channel token in storage logs

3. **If postal codes are empty:**
   - Check the channel token being used
   - Verify the GraphQL response contains postal codes
   - Check if there are any GraphQL errors

## Quick Test:

1. Run: `flutter run`
2. Navigate to Addresses page
3. Click "Add Address" button
4. Watch the console for the logs above


