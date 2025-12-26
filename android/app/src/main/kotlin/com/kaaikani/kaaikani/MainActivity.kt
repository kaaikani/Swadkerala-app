package com.kaaikani.kaaikani

import android.accounts.Account
import android.accounts.AccountManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.kaaikani.kaaikani/account_manager"
    private val TAG = "MainActivity"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getGoogleAccounts" -> {
                    try {
                        val accountManager = AccountManager.get(this)
                        
                        // Try different methods to get Google accounts
                        var accounts = arrayOf<Account>()
                        
                        // Method 1: Try "com.google" account type
                        try {
                            accounts = accountManager.getAccountsByType("com.google")
                            Log.d(TAG, "Found ${accounts.size} accounts with type 'com.google'")
                        } catch (e: Exception) {
                            Log.d(TAG, "Error getting accounts by type 'com.google': ${e.message}")
                        }
                        
                        // Method 2: If no accounts, try getting all accounts and filter
                        if (accounts.isEmpty()) {
                            try {
                                val allAccounts = accountManager.accounts
                                Log.d(TAG, "Total accounts on device: ${allAccounts.size}")
                                
                                // Log all account types for debugging
                                allAccounts.forEach { account ->
                                    Log.d(TAG, "Account: ${account.name}, Type: ${account.type}")
                                }
                                
                                // Filter for Google accounts (Gmail emails or Google account types)
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
    }
}

