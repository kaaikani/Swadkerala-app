package com.Swadkerala.Swadkerala

import android.accounts.Account
import android.accounts.AccountManager
import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.SystemClock
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.Swadkerala.Swadkerala/account_manager"
    private val TIMER_CHANNEL = "com.Swadkerala.Swadkerala/offer_timer"
    private val TAG = "MainActivity"
    private val OFFER_TIMER_CHANNEL_ID = "kaaikani_offer_timer"
    private val OFFER_TIMER_NOTIFICATION_ID = 9999
    private val TIMER_ALARM_REQUEST_CODE = 9998
    private var timerMethodChannel: MethodChannel? = null

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // When notification is tapped while app is already open
        val payload = intent.getStringExtra("offer_timer_payload") ?: ""
        if (payload.isNotEmpty()) {
            Log.d(TAG, "onNewIntent: timer payload=$payload")
            intent.removeExtra("offer_timer_payload")
            // Send to Dart immediately
            timerMethodChannel?.invokeMethod("onTimerTap", payload)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        Log.d(TAG, "MainActivity: FlutterEngine configured, plugins auto-registered")

        // Account manager channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getGoogleAccounts" -> {
                    try {
                        val accountManager = AccountManager.get(this)

                        var accounts = arrayOf<Account>()

                        try {
                            accounts = accountManager.getAccountsByType("com.google")
                            Log.d(TAG, "Found ${accounts.size} accounts with type 'com.google'")
                        } catch (e: Exception) {
                            Log.d(TAG, "Error getting accounts by type 'com.google': ${e.message}")
                        }

                        if (accounts.isEmpty()) {
                            try {
                                val allAccounts = accountManager.accounts
                                Log.d(TAG, "Total accounts on device: ${allAccounts.size}")

                                allAccounts.forEach { account ->
                                    Log.d(TAG, "Account: ${account.name}, Type: ${account.type}")
                                }

                                accounts = allAccounts.filter { account ->
                                    val isGmail = account.name.contains("@gmail.com", ignoreCase = true)
                                    val isGoogleType = account.type.contains("google", ignoreCase = true) ||
                                                      account.type == "com.google" ||
                                                      account.type.contains("com.google")
                                    isGmail || isGoogleType
                                }.toTypedArray()

                                Log.d(TAG, "Filtered ${accounts.size} Google accounts from all accounts")
                            } catch (e: Exception) {
                                Log.e(TAG, "Error getting all accounts: ${e.message}")
                            }
                        }

                        val accountList = accounts.map { account ->
                            mapOf(
                                "email" to account.name,
                                "type" to account.type
                            )
                        }

                        Log.d(TAG, "Returning ${accountList.size} Google accounts to Flutter")
                        result.success(accountList)
                    } catch (e: SecurityException) {
                        Log.e(TAG, "SecurityException: ${e.message}")
                        result.error("PERMISSION_ERROR", "Permission denied: ${e.message}", null)
                    } catch (e: Exception) {
                        Log.e(TAG, "Exception: ${e.message}")
                        result.error("ERROR", "Failed to get Google accounts: ${e.message}", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Offer timer notification channel
        timerMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TIMER_CHANNEL)
        timerMethodChannel!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "showOfferTimer" -> {
                    try {
                        val title = call.argument<String>("title") ?: "Offer Live!"
                        val body = call.argument<String>("body") ?: "Hurry, offer ends soon!"
                        val endTime = call.argument<Long>("endTime") ?: 0L
                        val endsAtText = call.argument<String>("endsAt") ?: ""
                        val colorHex = call.argument<String>("color") ?: "FF6B00"
                        val payload = call.argument<String>("payload") ?: ""

                        showCustomTimerNotification(title, body, endTime, endsAtText, colorHex, payload)
                        result.success(true)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error showing timer notification: ${e.message}")
                        result.error("ERROR", e.message, null)
                    }
                }
                "cancelOfferTimer" -> {
                    cancelTimerAlarm()
                    val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                    nm.cancel(OFFER_TIMER_NOTIFICATION_ID)
                    result.success(true)
                }
                "getTimerPayload" -> {
                    val payload = intent?.getStringExtra("offer_timer_payload") ?: ""
                    // Clear after reading so it doesn't trigger again
                    intent?.removeExtra("offer_timer_payload")
                    result.success(payload)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun showCustomTimerNotification(
        title: String,
        body: String,
        endTime: Long,
        endsAtText: String,
        colorHex: String,
        payload: String = ""
    ) {
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Create channel
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

        // Remaining time for chronometer
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

        // Tap intent - open app with navigation payload
        val intent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            if (payload.isNotEmpty()) {
                putExtra("offer_timer_payload", payload)
            }
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

        // Schedule alarm to cancel notification when timer expires (survives app death)
        scheduleTimerAlarm(endTime)
    }

    private fun scheduleTimerAlarm(endTimeMillis: Long) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, TimerExpiredReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            this, TIMER_ALARM_REQUEST_CODE, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        // Cancel any existing alarm first
        alarmManager.cancel(pendingIntent)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, endTimeMillis, pendingIntent)
        } else {
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, endTimeMillis, pendingIntent)
        }
        Log.d(TAG, "Scheduled timer alarm at $endTimeMillis")
    }

    private fun cancelTimerAlarm() {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, TimerExpiredReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            this, TIMER_ALARM_REQUEST_CODE, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.cancel(pendingIntent)
    }
}
