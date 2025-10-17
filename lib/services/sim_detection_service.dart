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
  
  // First-time install detection
  bool _isFirstTimeInstall = true;

  /// Check if phone permission is granted
  Future<bool> hasPhonePermission() async {
    try {
      return await MobileNumber.hasPhonePermission;
    } catch (e) {
      debugPrint('[SimDetectionService] Error checking permission: $e');
      return false;
    }
  }

  /// Request phone permission with better error handling
  Future<bool> requestPhonePermission() async {
    try {
      debugPrint('[SimDetectionService] Requesting phone permission...');
      
      // Try to request permission with shorter timeout
      await MobileNumber.requestPhonePermission.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('[SimDetectionService] Permission request timeout (5s)');
          return;
        },
      );
      
      bool granted = true; // Assume granted if no timeout
      
      debugPrint('[SimDetectionService] Permission request result: $granted');
      
      // Wait a bit for the system to process the permission grant
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Check if permission was actually granted
      bool hasPermission = await hasPhonePermission();
      debugPrint('[SimDetectionService] Final permission check: $hasPermission');
      
      if (granted && hasPermission) {
        debugPrint('[SimDetectionService] Permission granted successfully');
        return true;
      } else {
        debugPrint('[SimDetectionService] Permission not granted or timeout');
        return false;
      }
      
    } catch (e) {
      debugPrint('[SimDetectionService] Error requesting permission: $e');
      return false;
    }
  }

  /// Comprehensive dual SIM detection for both slots
  Future<List<SimInfo>> _tryComprehensiveDualSimDetection() async {
    List<SimInfo> allSims = [];
    
    try {
      debugPrint('[SimDetectionService] Starting comprehensive dual SIM detection...');
      
      // Method 1: Try getSimCards multiple times with different timeouts
      for (int attempt = 1; attempt <= 2; attempt++) {
        debugPrint('[SimDetectionService] Attempt $attempt: getSimCards with ${attempt * 2}s timeout');
        List<SimCard>? simCards = await MobileNumber.getSimCards?.timeout(
          Duration(seconds: attempt * 2),
          onTimeout: () => <SimCard>[],
        );
        
        if (simCards != null && simCards.isNotEmpty) {
          debugPrint('[SimDetectionService] Attempt $attempt found ${simCards.length} SIMs');
          for (SimCard card in simCards) {
            if (card.number != null && card.number!.isNotEmpty) {
              String cleanNumber = card.number!.replaceAll(RegExp(r'[^\d]'), '');
              if (cleanNumber.length >= 10) {
                bool isNew = _isDifferentSim(cleanNumber, allSims);
                if (isNew) {
                  allSims.add(SimInfo(
                    phoneNumber: cleanNumber,
                    carrierName: card.carrierName ?? 'SIM Slot ${card.slotIndex ?? 0}',
                    slotIndex: card.slotIndex ?? 0,
                    isActive: true,
                  ));
                  debugPrint('[SimDetectionService] Added SIM from attempt $attempt: $cleanNumber (Slot ${card.slotIndex})');
                }
              }
            }
          }
        }
        
        // If we found 2 SIMs, we can stop
        if (allSims.length >= 2) {
          debugPrint('[SimDetectionService] Found 2 SIMs, stopping attempts');
          break;
        }
      }
      
      // Method 2: Try mobileNumber method multiple times
      for (int attempt = 1; attempt <= 2; attempt++) {
        debugPrint('[SimDetectionService] Mobile number attempt $attempt');
        String? mobileNumber = await MobileNumber.mobileNumber?.timeout(
          Duration(seconds: attempt * 2),
          onTimeout: () => '',
        );
        
        if (mobileNumber != null && mobileNumber.isNotEmpty) {
          String cleanNumber = mobileNumber.replaceAll(RegExp(r'[^\d]'), '');
          if (cleanNumber.length >= 10) {
            bool isNew = _isDifferentSim(cleanNumber, allSims);
            if (isNew) {
              allSims.add(SimInfo(
                phoneNumber: cleanNumber,
                carrierName: 'Primary SIM',
                slotIndex: 0,
                isActive: true,
              ));
              debugPrint('[SimDetectionService] Added mobile number: $cleanNumber');
            }
          }
        }
      }
      
      // Method 3: Try to force detection of both slots
      debugPrint('[SimDetectionService] Trying slot-specific detection...');
      await _trySlotSpecificDetection(allSims);
      
    } catch (e) {
      debugPrint('[SimDetectionService] Error in comprehensive dual SIM detection: $e');
    }
    
    debugPrint('[SimDetectionService] Comprehensive detection found ${allSims.length} total SIMs');
    return allSims;
  }

  /// Try slot-specific detection methods
  Future<void> _trySlotSpecificDetection(List<SimInfo> allSims) async {
    try {
      // Try different approaches to detect both slots
      debugPrint('[SimDetectionService] Attempting slot-specific detection...');
      
      // Wait a bit between attempts
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Try getSimCards again with longer timeout
      List<SimCard>? slotSims = await MobileNumber.getSimCards?.timeout(
        const Duration(seconds: 4),
        onTimeout: () => <SimCard>[],
      );
      
      if (slotSims != null && slotSims.isNotEmpty) {
        debugPrint('[SimDetectionService] Slot detection found ${slotSims.length} SIMs');
        for (SimCard card in slotSims) {
          if (card.number != null && card.number!.isNotEmpty) {
            String cleanNumber = card.number!.replaceAll(RegExp(r'[^\d]'), '');
            if (cleanNumber.length >= 10) {
              bool isNew = _isDifferentSim(cleanNumber, allSims);
              if (isNew) {
                allSims.add(SimInfo(
                  phoneNumber: cleanNumber,
                  carrierName: card.carrierName ?? 'SIM Slot ${card.slotIndex ?? 1}',
                  slotIndex: card.slotIndex ?? 1,
                  isActive: true,
                ));
                debugPrint('[SimDetectionService] Added slot SIM: $cleanNumber (Slot ${card.slotIndex})');
              }
            }
          }
        }
      }
      
    } catch (e) {
      debugPrint('[SimDetectionService] Error in slot-specific detection: $e');
    }
  }


  /// Check if a SIM number is different from existing SIMs
  bool _isDifferentSim(String newNumber, List<SimInfo> existingSims) {
    if (existingSims.isEmpty) return true;
    
    for (SimInfo existing in existingSims) {
      // Compare last 10 digits of both numbers
      String existingLast10 = existing.phoneNumber.length >= 10 
          ? existing.phoneNumber.substring(existing.phoneNumber.length - 10)
          : existing.phoneNumber;
      String newLast10 = newNumber.length >= 10 
          ? newNumber.substring(newNumber.length - 10)
          : newNumber;
      
      if (existingLast10 == newLast10) {
        debugPrint('[SimDetectionService] Duplicate detected: $newNumber matches $existing.phoneNumber');
        return false;
      }
    }
    
    return true;
  }


  /// Alternative method to get SIM info using different approaches
  Future<List<SimInfo>> _getAlternativeSimInfo() async {
    List<SimInfo> simInfoList = [];
    
    try {
      debugPrint('[SimDetectionService] Trying alternative SIM detection methods...');
      
      // Method 1: Try getSimCards
      List<SimCard>? simCards = await MobileNumber.getSimCards?.timeout(
        const Duration(seconds: 3),
        onTimeout: () => <SimCard>[],
      );
      
      if (simCards != null && simCards.isNotEmpty) {
        debugPrint('[SimDetectionService] Alternative method found ${simCards.length} SIM cards');
        for (int i = 0; i < simCards.length; i++) {
          SimCard card = simCards[i];
          String? number = card.number;
          if (number != null && number.isNotEmpty) {
            String cleanNumber = number.replaceAll(RegExp(r'[^\d]'), '');
            if (cleanNumber.length >= 10) {
              simInfoList.add(SimInfo(
                phoneNumber: cleanNumber,
                carrierName: card.carrierName ?? 'SIM ${i + 1}',
                slotIndex: card.slotIndex ?? i,
                isActive: true,
              ));
            }
          }
        }
      }
      
      // Method 2: Try mobileNumber if no cards found
      if (simInfoList.isEmpty) {
        String? mobileNumber = await MobileNumber.mobileNumber?.timeout(
          const Duration(seconds: 2),
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
          }
        }
      }
      
    } catch (e) {
      debugPrint('[SimDetectionService] Alternative method error: $e');
    }
    
    return simInfoList;
  }

  /// Quick SIM detection for first-time installs
  Future<List<SimInfo>> getQuickSimInfo() async {
    List<SimInfo> simInfoList = [];
    
    try {
      debugPrint('[SimDetectionService] Quick SIM detection for first install...');
      
      // Check permission quickly
      bool hasPermission = await hasPhonePermission().timeout(
        const Duration(seconds: 2),
        onTimeout: () => false,
      );
      
      if (!hasPermission) {
        debugPrint('[SimDetectionService] No permission for quick detection');
        return simInfoList;
      }
      
      // Try to get mobile number directly (faster than getSimCards)
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
          debugPrint('[SimDetectionService] Quick detection found: $cleanNumber');
        }
      }
      
    } catch (e) {
      debugPrint('[SimDetectionService] Quick detection error: $e');
    }
    
    return simInfoList;
  }

  /// Get all available SIM information with timeout and caching
  Future<List<SimInfo>> getAllSimInfo() async {
    // Check cache first
    if (_cachedSimInfo != null && 
        _lastDetectionTime != null && 
        DateTime.now().difference(_lastDetectionTime!) < _cacheValidDuration) {
      debugPrint('[SimDetectionService] Using cached SIM info');
      return _cachedSimInfo!;
    }

    List<SimInfo> simInfoList = [];

    try {
      // Check permission first with timeout
      bool hasPermission = await hasPhonePermission().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          debugPrint('[SimDetectionService] Permission check timeout');
          return false;
        },
      );
      
      if (!hasPermission) {
        debugPrint('[SimDetectionService] No phone permission');
        return simInfoList;
      }

      // Get phone numbers from all SIMs with timeout
      List<SimCard>? simCards = await MobileNumber.getSimCards?.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('[SimDetectionService] SIM cards fetch timeout');
          return <SimCard>[];
        },
      );
      
      // Always try to detect both SIM slots, even if we found some
      debugPrint('[SimDetectionService] Attempting comprehensive dual SIM detection...');
      
      // Try multiple detection attempts to find all SIM slots
      List<SimInfo> additionalSims = await _tryComprehensiveDualSimDetection();
      if (additionalSims.isNotEmpty) {
        debugPrint('[SimDetectionService] Found ${additionalSims.length} additional SIMs via comprehensive detection');
        // Convert SimInfo back to SimCard for processing
        for (SimInfo simInfo in additionalSims) {
          // Check if this SIM is already in the list
          bool alreadyExists = false;
          if (simCards != null) {
            for (SimCard existingCard in simCards) {
            if (existingCard.number != null && existingCard.number!.isNotEmpty) {
              String existingClean = existingCard.number!.replaceAll(RegExp(r'[^\d]'), '');
              String newClean = simInfo.phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
              if (existingClean.length >= 10 && newClean.length >= 10) {
                String existingLast10 = existingClean.substring(existingClean.length - 10);
                String newLast10 = newClean.substring(newClean.length - 10);
                if (existingLast10 == newLast10) {
                  alreadyExists = true;
                  break;
                }
              }
            }
          }
          }
          
          if (!alreadyExists && simCards != null) {
            simCards.add(SimCard(
              number: simInfo.phoneNumber,
              carrierName: simInfo.carrierName,
              slotIndex: simInfo.slotIndex,
              countryIso: 'in',
              countryPhonePrefix: '91',
              displayName: simInfo.carrierName,
            ));
            debugPrint('[SimDetectionService] Added additional SIM: ${simInfo.phoneNumber} (Slot ${simInfo.slotIndex})');
          } else {
            debugPrint('[SimDetectionService] Skipping duplicate SIM: ${simInfo.phoneNumber}');
          }
        }
      }
      
      debugPrint('[SimDetectionService] Raw SIM cards response: $simCards');
      debugPrint('[SimDetectionService] SIM cards count: ${simCards?.length ?? 0}');
      
      if (simCards != null) {
        for (int i = 0; i < simCards.length; i++) {
          SimCard card = simCards[i];
          debugPrint('[SimDetectionService] SIM $i details:');
          debugPrint('  - Number: ${card.number}');
          debugPrint('  - Carrier: ${card.carrierName}');
          debugPrint('  - Slot: ${card.slotIndex}');
          debugPrint('  - Country: ${card.countryIso}');
          debugPrint('  - Prefix: ${card.countryPhonePrefix}');
          debugPrint('  - Display: ${card.displayName}');
        }
      }
      
      if (simCards == null || simCards.isEmpty) {
        debugPrint('[SimDetectionService] No SIM cards returned, trying legacy method');
        
        // Try legacy method with timeout
        String? mobileNumber = await MobileNumber.mobileNumber?.timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            debugPrint('[SimDetectionService] Legacy method timeout');
            return '';
          },
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
            debugPrint('[SimDetectionService] Legacy method found: $cleanNumber');
          }
        }
        
        return simInfoList;
      }
      
      debugPrint('[SimDetectionService] Found ${simCards.length} SIM cards');

      // Process SIM cards quickly
      for (int i = 0; i < simCards.length; i++) {
        SimCard simCard = simCards[i];
        String? phoneNumber = simCard.number;
        
        debugPrint('[SimDetectionService] Processing SIM $i: number=$phoneNumber, carrier=${simCard.carrierName}');
        
        if (phoneNumber != null && phoneNumber.isNotEmpty) {
          // Clean the phone number (remove any non-digit characters)
          String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
          
          if (cleanNumber.length >= 10) {
            // Check for duplicates before adding
            bool isDuplicate = _isDifferentSim(cleanNumber, simInfoList) == false;
            
            if (!isDuplicate) {
              simInfoList.add(SimInfo(
                phoneNumber: cleanNumber,
                carrierName: simCard.carrierName ?? 'Unknown Carrier',
                slotIndex: simCard.slotIndex ?? i,
                isActive: true, // Assume active if we can get the number
              ));
              debugPrint('[SimDetectionService] Added SIM $i: $cleanNumber (${simCard.carrierName})');
            } else {
              debugPrint('[SimDetectionService] Skipping duplicate SIM $i: $cleanNumber');
            }
          } else {
            debugPrint('[SimDetectionService] SIM $i number too short: $cleanNumber');
          }
        } else {
          debugPrint('[SimDetectionService] SIM $i has no phone number');
          // Even if no phone number, we can still show the SIM for manual entry
          simInfoList.add(SimInfo(
            phoneNumber: '', // Empty number
            carrierName: simCard.carrierName ?? 'SIM ${i + 1}',
            slotIndex: simCard.slotIndex ?? i,
            isActive: false,
          ));
        }
      }

    } catch (e) {
      debugPrint('[SimDetectionService] Error getting SIM info: $e');
    }

    // If no SIMs found, try alternative method
    if (simInfoList.isEmpty) {
      debugPrint('[SimDetectionService] No SIMs found with primary method, trying alternative...');
      simInfoList = await _getAlternativeSimInfo();
    }

    // Update cache
    _cachedSimInfo = simInfoList;
    _lastDetectionTime = DateTime.now();

    debugPrint('[SimDetectionService] Final result: ${simInfoList.length} SIM cards detected');
    return simInfoList;
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

  /// Mark that the app has been used (not first-time install)
  void markAppUsed() {
    _isFirstTimeInstall = false;
    debugPrint('[SimDetectionService] App marked as used');
  }

  /// Check if this is first-time install
  bool get isFirstTimeInstall => _isFirstTimeInstall;

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
