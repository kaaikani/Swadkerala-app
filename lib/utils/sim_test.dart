import 'package:flutter/material.dart';
import '../services/sim_detection_service.dart';

/// Test utility to verify SIM detection functionality
class SimTest {
  static Future<void> testSimDetection(BuildContext context) async {
    debugPrint('[SimTest] Starting SIM detection test...');
    
    final simService = SimDetectionService();
    
    // Test permission check
    bool hasPermission = await simService.hasPhonePermission();
    debugPrint('[SimTest] Has phone permission: $hasPermission');
    
    if (!hasPermission) {
      debugPrint('[SimTest] Requesting phone permission...');
      hasPermission = await simService.requestPhonePermission();
      debugPrint('[SimTest] Permission granted: $hasPermission');
    }
    
    if (hasPermission) {
      // Test getting all SIM info
      List<SimInfo> simInfoList = await simService.getAllSimInfo();
      debugPrint('[SimTest] Found ${simInfoList.length} SIM cards');
      
      for (int i = 0; i < simInfoList.length; i++) {
        SimInfo simInfo = simInfoList[i];
        debugPrint('[SimTest] SIM $i: ${simInfo.phoneNumber.isEmpty ? "No number" : simInfo.last10Digits} (${simInfo.carrierName}) [Active: ${simInfo.isActive}]');
      }
      
      // Test primary SIM
      String? primarySim = await simService.getPrimarySimNumber();
      debugPrint('[SimTest] Primary SIM: $primarySim');
      
      // Test SIM selection dialog if multiple SIMs
      if (simInfoList.length > 1) {
        debugPrint('[SimTest] Testing SIM selection dialog...');
        SimInfo? selectedSim = await simService.showSimSelectionDialog(context, simInfoList);
        if (selectedSim != null) {
          debugPrint('[SimTest] Selected SIM: ${selectedSim.phoneNumber.isEmpty ? "No number" : selectedSim.last10Digits}');
        } else {
          debugPrint('[SimTest] No SIM selected');
        }
      } else if (simInfoList.length == 1) {
        debugPrint('[SimTest] Single SIM detected - should auto-fill');
      } else {
        debugPrint('[SimTest] No SIM cards detected');
      }
    }
    
    debugPrint('[SimTest] SIM detection test completed');
  }
}
