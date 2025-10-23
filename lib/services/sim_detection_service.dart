import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_number/mobile_number.dart';

class SimInfo {
  final String phoneNumber;
  final String carrierName;
  final int slotIndex;
  final bool isActive;

  SimInfo({
    required this.phoneNumber,
    required this.carrierName,
    required this.slotIndex,
    required this.isActive,
  });

  String get last10Digits {
    if (phoneNumber.length >= 10) {
      return phoneNumber.substring(phoneNumber.length - 10);
    }
    return phoneNumber;
  }
}

class SimDetectionService {
  static final SimDetectionService _instance = SimDetectionService._internal();
  factory SimDetectionService() => _instance;
  SimDetectionService._internal();

  // Cache for SIM detection results
  List<SimInfo>? _cachedSimInfo;
  DateTime? _lastDetectionTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);
  
  /// Check if phone permission is granted
  Future<bool> hasPhonePermission() async {
    try {
      return await MobileNumber.hasPhonePermission;
    } catch (e) {
      debugPrint('[SimDetectionService] Error checking permission: $e');
      return false;
    }
  }

  /// Request phone permission
  Future<bool> requestPhonePermission() async {
    try {
      debugPrint('[SimDetectionService] Requesting phone permission...');
      
      // Try multiple approaches to request permission
      bool permissionGranted = false;
      
      // Method 1: Try mobile_number package with longer timeout
      try {
        await MobileNumber.requestPhonePermission.timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            debugPrint('[SimDetectionService] Mobile number permission request timeout');
          },
        );
        
        // Wait for permission to be processed
        await Future.delayed(const Duration(milliseconds: 1000));
        
        permissionGranted = await hasPhonePermission();
        debugPrint('[SimDetectionService] Mobile number permission result: $permissionGranted');
    } catch (e) {
        debugPrint('[SimDetectionService] Mobile number permission error: $e');
      }
      
      // Method 2: If still not granted, try again with shorter delay
      if (!permissionGranted) {
        debugPrint('[SimDetectionService] Trying permission request again...');
        await Future.delayed(const Duration(milliseconds: 500));
        
        try {
          await MobileNumber.requestPhonePermission.timeout(
          const Duration(seconds: 5),
            onTimeout: () {
              debugPrint('[SimDetectionService] Second permission request timeout');
            },
          );
          
          await Future.delayed(const Duration(milliseconds: 800));
          permissionGranted = await hasPhonePermission();
          debugPrint('[SimDetectionService] Second permission result: $permissionGranted');
    } catch (e) {
          debugPrint('[SimDetectionService] Second permission request error: $e');
        }
      }
      
      debugPrint('[SimDetectionService] Final permission result: $permissionGranted');
      return permissionGranted;
    } catch (e) {
      debugPrint('[SimDetectionService] Error requesting permission: $e');
      return false;
    }
  }

  /// Get all available SIM information with timeout and caching
  Future<List<SimInfo>> getAllSimInfo({bool forcePermissionRequest = false}) async {
    // Check cache first (but not if forcing permission request)
    if (!forcePermissionRequest && 
        _cachedSimInfo != null && 
        _lastDetectionTime != null && 
        DateTime.now().difference(_lastDetectionTime!) < _cacheValidDuration) {
      debugPrint('[SimDetectionService] Using cached SIM info');
      return _cachedSimInfo!;
    }

    List<SimInfo> simInfoList = [];

    try {
      // Check permission first
      bool hasPermission = await hasPhonePermission().timeout(
        const Duration(seconds: 2),
        onTimeout: () => false,
      );
      
      if (!hasPermission) {
        debugPrint('[SimDetectionService] No phone permission - will return empty list');
        return simInfoList;
      }

      // Get SIM cards with timeout
      List<SimCard>? simCards = await MobileNumber.getSimCards?.timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          debugPrint('[SimDetectionService] SIM cards fetch timeout');
          return <SimCard>[];
        },
      );
      
      debugPrint('[SimDetectionService] Found ${simCards?.length ?? 0} SIM cards');
      
      if (simCards != null && simCards.isNotEmpty) {
        // Process all SIM cards
        for (int i = 0; i < simCards.length; i++) {
          SimCard card = simCards[i];
          String? phoneNumber = card.number;
          
          if (phoneNumber != null && phoneNumber.isNotEmpty) {
            String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
            
            if (cleanNumber.length >= 10) {
              // Check for duplicates
              bool isDuplicate = false;
              for (SimInfo existing in simInfoList) {
                if (existing.last10Digits == cleanNumber.substring(cleanNumber.length - 10)) {
                  isDuplicate = true;
                  break;
                }
              }
              
              if (!isDuplicate) {
                simInfoList.add(SimInfo(
                  phoneNumber: cleanNumber,
                  carrierName: card.carrierName ?? 'SIM Slot ${card.slotIndex ?? i}',
                  slotIndex: card.slotIndex ?? i,
                  isActive: true,
                ));
                debugPrint('[SimDetectionService] Added SIM: $cleanNumber (${card.carrierName})');
              }
            }
          }
        }
      }
      
      // If no SIMs found, try mobileNumber method
      if (simInfoList.isEmpty) {
        debugPrint('[SimDetectionService] No SIMs found, trying mobileNumber method');
        
        String? mobileNumber = await MobileNumber.mobileNumber?.timeout(
          const Duration(seconds: 3),
          onTimeout: () => '',
        );
        
        if (mobileNumber != null && mobileNumber.isNotEmpty) {
          String cleanNumber = mobileNumber.replaceAll(RegExp(r'[^\d]'), '');
          if (cleanNumber.length >= 10) {
            simInfoList.add(SimInfo(
              phoneNumber: cleanNumber,
              carrierName: 'Primary SIM',
              slotIndex: 0,
              isActive: true,
            ));
            debugPrint('[SimDetectionService] Found via mobileNumber: $cleanNumber');
          }
        }
      }

    } catch (e) {
      debugPrint('[SimDetectionService] Error getting SIM info: $e');
    }

    // Update cache
    _cachedSimInfo = simInfoList;
    _lastDetectionTime = DateTime.now();

    debugPrint('[SimDetectionService] Final result: ${simInfoList.length} SIM cards detected');
    return simInfoList;
  }

  /// Get all SIM info with permission retry logic
  Future<List<SimInfo>> getAllSimInfoWithRetry() async {
    try {
      // Check permission
      bool hasPermission = await hasPhonePermission();
      debugPrint('[SimDetectionService] Permission check: $hasPermission');

      if (!hasPermission) {
        debugPrint('[SimDetectionService] Requesting permission...');
        hasPermission = await requestPhonePermission();
        debugPrint('[SimDetectionService] Permission result: $hasPermission');

        if (!hasPermission) {
          debugPrint('[SimDetectionService] Permission denied, returning empty list');
          return [];
        }
      }

      // Get SIM info
      List<SimInfo> simInfoList = await getAllSimInfo(forcePermissionRequest: true);

      // Optional: check again if no SIMs found
      if (simInfoList.isEmpty) {
        debugPrint('[SimDetectionService] No SIMs found, rechecking permission...');
        if (await hasPhonePermission()) {
          simInfoList = await getAllSimInfo(forcePermissionRequest: true);
        }
      }

      return simInfoList;
    } catch (e) {
      debugPrint('[SimDetectionService] Error in getAllSimInfoWithRetry: $e');
      return [];
    }
  }

  /// Get the primary/active SIM number
  Future<String?> getPrimarySimNumber() async {
    try {
      List<SimInfo> simInfoList = await getAllSimInfo();
      
      if (simInfoList.isEmpty) {
        return null;
      }

      // Find active SIM first
      for (SimInfo simInfo in simInfoList) {
        if (simInfo.isActive) {
          return simInfo.last10Digits;
        }
      }

      // If no active SIM found, return the first one
      return simInfoList.first.last10Digits;
    } catch (e) {
      debugPrint('[SimDetectionService] Error getting primary SIM: $e');
      return null;
    }
  }

  /// Clear cached SIM information
  void clearCache() {
    _cachedSimInfo = null;
    _lastDetectionTime = null;
    debugPrint('[SimDetectionService] Cache cleared');
  }

  /// Show SIM selection dialog
  Future<SimInfo?> showSimSelectionDialog(BuildContext context, List<SimInfo> simInfoList) async {
    if (simInfoList.isEmpty) {
      return null;
    }

    if (simInfoList.length == 1) {
      return simInfoList.first;
    }

    return await showDialog<SimInfo>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select SIM Card'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: simInfoList.map((simInfo) {
              String displayNumber = simInfo.phoneNumber.isEmpty 
                  ? 'No number detected' 
                  : '+91 ${simInfo.last10Digits}';
              
              return ListTile(
                title: Text(displayNumber),
                subtitle: Text('${simInfo.carrierName} ${simInfo.isActive ? '(Active)' : '(No number)'}'),
                leading: Icon(
                  simInfo.phoneNumber.isEmpty ? Icons.sim_card_alert : Icons.sim_card,
                  color: simInfo.phoneNumber.isEmpty ? Colors.orange : Colors.blue,
                ),
                onTap: () {
                  Navigator.of(context).pop(simInfo);
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}