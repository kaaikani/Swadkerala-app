package com.Swadkerala.Swadkerala

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class TimerExpiredReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        Log.d("TimerExpiredReceiver", "Timer expired - cancelling notification")
        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.cancel(9999) // OFFER_TIMER_NOTIFICATION_ID
    }
}
