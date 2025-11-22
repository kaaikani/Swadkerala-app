# Snapchat-Style Heads-Up Notifications Setup

## ✅ Implementation Complete

Your Flutter app now supports **Snapchat-style heads-up notifications** that appear at the top of the screen even when the app is **CLOSED**.

## How It Works

### When App is CLOSED:
- FCM receives the notification
- Android shows a **system heads-up notification** (banner at top)
- User taps it → Opens your app

### When App is OPEN:
- FCM receives the notification
- Shows heads-up notification + in-app snackbar

## Configuration Applied

### 1. High Importance Notification Channel
```dart
AndroidNotificationChannel(
  'kaaikani_updates',
  'Kaaikani Updates',
  importance: Importance.high, // ← KEY: High importance = Heads-up
  playSound: true,
  enableVibration: true,
  showBadge: true,
)
```

### 2. High Priority Notifications
```dart
AndroidNotificationDetails(
  importance: Importance.high,  // Heads-up banner
  priority: Priority.high,        // Shows when app closed
  playSound: true,
  enableVibration: true,
)
```

## Sending FCM Notifications

### Option 1: Using Firebase Console
1. Go to Firebase Console → Cloud Messaging
2. Send notification with:
   - **Title**: Your notification title
   - **Text**: Your notification body
   - **Android**: 
     - Channel ID: `kaaikani_u✅ HOW TO FIX (Step-by-step)
1. Scroll down to “Additional options (optional)”

Click the arrow ↓ to expand it.
2. Inside “Custom data”, add these:

Key: channel_id
Value: kaaikani_updates

Key: priority
Value: high

Key: sound
Value: defaultpdates` (important!)
     - Priority: High
     - Sound: Enabled

### Option 2: Using FCM API (Recommended)

#### HTTP v1 API Request:
```json
{
  "message": {
    "token": "USER_FCM_TOKEN",
    "notification": {
      "title": "New Order!",
      "body": "Your order #1234 has been confirmed"
    },
    "android": {
      "priority": "high",
      "notification": {
        "channel_id": "kaaikani_updates",
        "sound": "default",
        "priority": "high"
      }
    },
    "data": {
      "order_id": "1234",
      "type": "order_update"
    }
  }
}
```

#### cURL Example:
```bash
curl -X POST https://fcm.googleapis.com/v1/projects/YOUR_PROJECT_ID/messages:send \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "message": {
      "token": "USER_FCM_TOKEN",
      "notification": {
        "title": "New Order!",
        "body": "Your order has been confirmed"
      },
      "android": {
        "priority": "high",
        "notification": {
          "channel_id": "kaaikani_updates",
          "sound": "default",
          "priority": "high"
        }
      }
    }
  }'
```

#### Node.js Example:
```javascript
const admin = require('firebase-admin');

const message = {
  token: 'USER_FCM_TOKEN',
  notification: {
    title: 'New Order!',
    body: 'Your order has been confirmed',
  },
  android: {
    priority: 'high',
    notification: {
      channelId: 'kaaikani_updates',
      sound: 'default',
      priority: 'high',
    },
  },
  data: {
    order_id: '1234',
    type: 'order_update',
  },
};

admin.messaging().send(message);
```

## Key Points

### ✅ What Makes It Work:
1. **High Importance Channel** (`Importance.high`) - Required for heads-up
2. **High Priority** (`Priority.high`) - Shows when app is closed
3. **Correct Channel ID** (`kaaikani_updates`) - Must match in FCM payload
4. **FCM Priority** (`"priority": "high"`) - In Android notification config

### ⚠️ Important Notes:

1. **Channel ID Must Match**: 
   - Your code uses: `kaaikani_updates`
   - FCM payload must use: `channel_id: "kaaikani_updates"`

2. **Android 8.0+ (API 26+)**:
   - Notification channels are required
   - High importance channels show heads-up notifications
   - User can disable heads-up in system settings (but can't change importance)

3. **Battery Optimization**:
   - Some devices may suppress heads-up if battery saver is on
   - User can whitelist your app in battery settings

4. **Do Not Disturb Mode**:
   - Heads-up notifications respect DND settings
   - Users can allow "Priority" notifications in DND

## Testing

### Test When App is Closed:
1. Close your app completely
2. Send FCM notification with high priority
3. **Expected**: Heads-up banner appears at top of screen
4. Tap it → App opens

### Test When App is Open:
1. Open your app
2. Send FCM notification
3. **Expected**: 
   - Heads-up banner appears
   - In-app snackbar also shows (if app is in foreground)

## Troubleshooting

### Heads-up not showing?

1. **Check Channel Importance**:
   ```dart
   // Must be Importance.high
   importance: Importance.high
   ```

2. **Check FCM Payload**:
   ```json
   {
     "android": {
       "priority": "high",
       "notification": {
         "channel_id": "kaaikani_updates",
         "priority": "high"
       }
     }
   }
   ```

3. **Check Device Settings**:
   - Settings → Apps → Kaaikani → Notifications
   - Ensure "Kaaikani Updates" channel is enabled
   - Check if "Show on lock screen" is enabled

4. **Check Battery Optimization**:
   - Settings → Battery → Battery Optimization
   - Ensure Kaaikani is not optimized

5. **Check Do Not Disturb**:
   - Ensure DND allows priority notifications

## Code Location

- **Notification Service**: `lib/services/notification_service.dart`
- **Channel ID**: `kaaikani_updates`
- **Channel Name**: `Kaaikani Updates`

## Summary

✅ **High Importance Channel** → Heads-up notifications  
✅ **High Priority** → Shows when app closed  
✅ **FCM Integration** → Works with Firebase Cloud Messaging  
✅ **Snapchat-Style** → Banner appears at top of screen  

Your app now has Snapchat-style heads-up notifications! 🎉

