package com.Swadkerala.Swadkerala

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.SystemClock
import android.util.Log
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

/**
 * Native FCM service that handles offer_timer notifications even when the app
 * is closed/killed. This bypasses Flutter entirely so the Chronometer widget
 * works regardless of app state.
 *
 * For non-timer messages, it does nothing and lets the Flutter plugin handle them.
 */
class OfferTimerFcmService : FirebaseMessagingService() {

    companion object {
        private const val TAG = "OfferTimerFcmService"
        private const val OFFER_TIMER_CHANNEL_ID = "kaaikani_offer_timer"
        private const val OFFER_TIMER_NOTIFICATION_ID = 9999
    }

    override fun onMessageReceived(message: RemoteMessage) {
        val data = message.data
        val type = data["type"]?.lowercase() ?: ""

        Log.d(TAG, "onMessageReceived - type: $type, data: $data")

        if (type == "offer_timer") {
            handleOfferTimerNotification(data, message)
        } else {
            // Let Flutter firebase_messaging plugin handle non-timer messages
            super.onMessageReceived(message)
        }
    }

    private fun handleOfferTimerNotification(
        data: Map<String, String>,
        message: RemoteMessage
    ) {
        val endTimeStr = data["offer_end_time"] ?: data["offerEndTime"] ?: ""
        val endTime = endTimeStr.toLongOrNull()
        val now = System.currentTimeMillis()

        if (endTime == null || endTime <= now) {
            Log.d(TAG, "Skipped - offer expired or invalid endTime: $endTimeStr")
            return
        }

        val title = data["title"] ?: message.notification?.title ?: "Offer Live!"
        val body = data["body"] ?: message.notification?.body ?: "Hurry, offer ends soon!"
        val colorHex = (data["color"] ?: data["accent_color"] ?: "FF6B00").removePrefix("#")
        val payload = org.json.JSONObject(data as Map<*, *>).toString()

        showTimerNotification(title, body, endTime, colorHex, payload)
    }

    private fun showTimerNotification(
        title: String,
        body: String,
        endTime: Long,
        colorHex: String,
        payload: String
    ) {
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Create notification channel
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                OFFER_TIMER_CHANNEL_ID,
                "Offer Timers",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Flash sale and offer countdown timers"
                enableVibration(true)
            }
            nm.createNotificationChannel(channel)
        }

        val accentColor = try {
            Color.parseColor("#$colorHex")
        } catch (e: Exception) {
            Color.parseColor("#FF6B00")
        }

        // Chronometer countdown base
        val remaining = endTime - System.currentTimeMillis()
        val chronometerBase = SystemClock.elapsedRealtime() + remaining

        // Collapsed view
        val collapsedView = RemoteViews(packageName, R.layout.notification_offer_timer).apply {
            setTextViewText(R.id.notification_title, "\uD83D\uDD25 $title")
            setTextViewText(R.id.notification_body, body)
            setTextColor(R.id.notification_timer, accentColor)
            setChronometerCountDown(R.id.notification_timer, true)
            setChronometer(R.id.notification_timer, chronometerBase, null, true)
        }

        // Expanded view
        val expandedView = RemoteViews(packageName, R.layout.notification_offer_timer_expanded).apply {
            setTextViewText(R.id.notification_title, "\uD83D\uDD25 $title")
            setTextViewText(R.id.notification_body, body)
            setTextColor(R.id.notification_timer, accentColor)
            setTextColor(R.id.notification_action, accentColor)
            setChronometerCountDown(R.id.notification_timer, true)
            setChronometer(R.id.notification_timer, chronometerBase, null, true)
        }

        // Tap intent - open app with payload
        val intent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra("offer_timer_payload", payload)
        }
        val pendingIntent = PendingIntent.getActivity(
            this, OFFER_TIMER_NOTIFICATION_ID, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(this, OFFER_TIMER_CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setColor(accentColor)
            .setColorized(true)
            .setCustomContentView(collapsedView)
            .setCustomBigContentView(expandedView)
            .setStyle(NotificationCompat.DecoratedCustomViewStyle())
            .setOngoing(true)
            .setAutoCancel(false)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setContentIntent(pendingIntent)
            .build()

        nm.notify(OFFER_TIMER_NOTIFICATION_ID, notification)
        Log.d(TAG, "Timer notification shown - remaining: ${remaining / 1000}s")
    }
}
