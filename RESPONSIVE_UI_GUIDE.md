# Responsive UI Implementation Guide

## Overview
All pages and components must use `ResponsiveUtils` for consistent UI across all phone sizes.

## Rules

### 1. Always Use ResponsiveUtils
- **Font Sizes**: Use `ResponsiveUtils.sp(size)` instead of hardcoded `fontSize: 16`
- **Padding/Margins**: Use `ResponsiveUtils.rp(size)` instead of hardcoded `EdgeInsets.all(16)`
- **Icon Sizes**: Use `ResponsiveUtils.rp(size)` instead of hardcoded `size: 24`
- **Width/Height**: Use `ResponsiveUtils.rp(size)` instead of hardcoded `width: 100`

### 2. Common Patterns to Fix

#### ❌ Wrong (Hardcoded):
```dart
TextStyle(fontSize: 16)
EdgeInsets.all(16)
SizedBox(width: 12)
Icon(size: 24)
Container(width: 100)
```

#### ✅ Correct (Responsive):
```dart
TextStyle(fontSize: ResponsiveUtils.sp(16))
EdgeInsets.all(ResponsiveUtils.rp(16))
SizedBox(width: ResponsiveUtils.rp(12))
Icon(size: ResponsiveUtils.rp(24))
Container(width: ResponsiveUtils.rp(100))
```

### 3. Import Required
```dart
import '../utils/responsive.dart'; // or appropriate relative path
```

### 4. ResponsiveUtils Methods
- `ResponsiveUtils.sp(double)` - For font sizes
- `ResponsiveUtils.rp(double)` - For padding, margins, sizes, widths, heights
- `ResponsiveUtils.wp(double)` - For width percentage
- `ResponsiveUtils.hp(double)` - For height percentage

## Files to Check
All files in:
- `lib/pages/`
- `lib/components/`
- `lib/widgets/`

## Quick Fix Script
Search for these patterns and replace:
1. `fontSize: [0-9]+` → `fontSize: ResponsiveUtils.sp([number])`
2. `EdgeInsets.all([0-9]+)` → `EdgeInsets.all(ResponsiveUtils.rp([number]))`
3. `SizedBox(width: [0-9]+)` → `SizedBox(width: ResponsiveUtils.rp([number]))`
4. `SizedBox(height: [0-9]+)` → `SizedBox(height: ResponsiveUtils.rp([number]))`
5. `size: [0-9]+` → `size: ResponsiveUtils.rp([number])`

