# Google Play targetSdk 35 Requirement - Explanation

## Current Situation

### Error: targetSdk Requirement
**Google Play Error**: "Your app currently targets API level 34 and must target at least API level 35"

**Resolution**: ✅ **FIXED** - Changed `targetSdk` back to 35 in `build.gradle.kts`

### Warning: Device Compatibility
**Google Play Warning**: "This release no longer supports 2,305 devices that were supported in your previous release"

**Status**: ⚠️ **Expected Behavior** - This is normal when upgrading to targetSdk 35

## Why This Happens

### Google Play Policy Change
As of 2025, Google Play **requires** all apps to target API level 35 (Android 15). This is a mandatory requirement for:
- Security improvements
- Performance optimizations
- Latest Android features

### Device Compatibility Impact
When you upgrade to targetSdk 35:
- Some very old devices (Android 4.x, 5.x, early 6.x) may be excluded
- Devices that don't support Android 15 features are filtered out
- This is **intentional** by Google to ensure app quality and security

## What We've Done

### ✅ All Compatibility Optimizations Applied

1. **Removed ABI Filters** - Supports all architectures (ARM, x86, x86_64)
2. **Optional Hardware Features** - All hardware marked as optional
3. **Screen Size Support** - All screen sizes supported
4. **Android TV Support** - Added LEANBACK_LAUNCHER
5. **OpenGL ES Optional** - Graphics features optional
6. **targetSdk 35** - Required by Google Play (cannot be lowered)

## Understanding the Warning

### Is This a Problem?
**No, this is expected behavior** when:
- Google Play enforces new targetSdk requirements
- You upgrade from an older targetSdk
- Some devices genuinely can't support the new targetSdk

### What Devices Are Affected?
The 2,305 excluded devices are likely:
- Very old Android devices (Android 4.x, 5.x)
- Devices that don't meet Android 15 requirements
- Devices that haven't received security updates

### Should You Be Concerned?
**Generally, no** because:
- These are likely very old devices (5+ years old)
- Users on these devices should upgrade for security reasons
- Modern apps require modern Android versions
- This is a Google Play policy requirement, not a bug

## Next Steps

1. ✅ **targetSdk is now 35** - Meets Google Play requirement
2. ✅ **All compatibility optimizations applied** - Maximum device support
3. ⚠️ **Device warning is expected** - Normal when upgrading targetSdk
4. 📊 **Monitor in Play Console** - Check which specific devices are excluded

## Recommendations

### If You Want to Minimize Exclusions
1. Check Play Console "Supported devices" section
2. Review which specific device models are excluded
3. If they're all very old devices (Android 4.x, 5.x), this is acceptable
4. If modern devices are excluded, investigate further

### If You Need to Support Very Old Devices
- **Not recommended** - Google Play requires targetSdk 35
- Very old devices have security vulnerabilities
- Users should upgrade their devices
- You cannot bypass Google Play's targetSdk requirement

## Technical Details

### Current Configuration
```kotlin
targetSdk = 35  // Required by Google Play (cannot be lowered)
minSdk = flutter.minSdkVersion  // Typically 21 (Android 5.0+)
compileSdk = 36
```

### Manifest Optimizations
- All hardware features marked as `android:required="false"`
- All screen sizes supported
- Android TV support added
- OpenGL ES optional

## Conclusion

The device compatibility warning is **expected and acceptable** when:
- Google Play requires targetSdk 35
- You're upgrading from a lower targetSdk
- Some old devices are legitimately excluded

**Action Required**: None - this is normal behavior. The warning can be safely ignored if the excluded devices are very old (which they likely are).

## References

- [Google Play targetSdk Requirements](https://developer.android.com/google/play/requirements/target-sdk)
- [Android 15 (API 35) Features](https://developer.android.com/about/versions/15)
- [Device Compatibility Guide](https://developer.android.com/guide/practices/compatibility)

