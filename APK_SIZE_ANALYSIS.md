# APK Size Analysis & Optimization Plan

## Current Status
- **APK Size**: 61.3MB
- **Target**: < 40MB

## Major Size Contributors Found

### 1. GraphQL Generated Files (4.8MB) ⚠️ LARGEST ISSUE
```
order.graphql.dart:        2.0MB
vendureSchema.graphql.dart: 656KB
schema.graphql.dart:        640KB
cart.graphql.dart:          468KB
banner.graphql.dart:        420KB
Customer.graphql.dart:      360KB
product.graphql.dart:       216KB
Total:                     ~4.8MB
```

**Problem**: These generated files contain the entire GraphQL schema, including unused types and fields.

**Solutions**:
1. ✅ Enable tree-shaking (already done via minifyEnabled)
2. ⚠️ Optimize GraphQL queries to only request needed fields
3. ⚠️ Consider splitting large queries into smaller ones
4. ⚠️ Remove unused GraphQL fragments

### 2. Dependencies Analysis

**Large Dependencies**:
- `firebase_core` + `firebase_messaging`: ~5-8MB
- `graphql_flutter`: ~2-3MB
- `flutter_html`: ~1-2MB
- `razorpay_flutter`: ~1-2MB
- `skeletonizer`: ~500KB
- `marquee`: ~200KB

**Potentially Removable**:
- `marquee`: Only used for scrolling text - can be replaced with simpler widget
- `skeletonizer`: Can use simpler loading states

### 3. Assets
- `assets/images/`: 4KB ✅ (Already optimized)

## Optimization Actions

### Immediate Actions (High Impact)

1. **Optimize GraphQL Queries** (Expected: -2-3MB)
   - Review and minimize fields in queries
   - Remove unused fragments
   - Split large queries

2. **Remove Unused Dependencies** (Expected: -1-2MB)
   - Evaluate if `marquee` is essential
   - Consider lighter alternatives

3. **Enable Split APKs** (Expected: -20-30MB per APK)
   - Build separate APKs per architecture
   - Each device only downloads what it needs

4. **Build App Bundle Instead** (Expected: -30-40% download size)
   - Play Store generates optimized APKs
   - Users only get what they need

### Medium Priority Actions

5. **Optimize ProGuard Rules**
   - Allow more aggressive shrinking
   - Remove unnecessary keep rules

6. **Review Large Files**
   - Check if `order.graphql.dart` (2MB) can be split
   - Optimize GraphQL schema generation

7. **Remove Debug Code**
   - Ensure all debug prints are removed in release
   - Remove test files from release build

## Implementation Priority

1. ✅ **DONE**: Enable minification and resource shrinking
2. ✅ **DONE**: Add ProGuard rules
3. ⏳ **TODO**: Optimize GraphQL queries
4. ⏳ **TODO**: Remove unused dependencies
5. ⏳ **TODO**: Enable split APKs or build AAB

## Expected Results

After all optimizations:
- **Current**: 61.3MB
- **After GraphQL optimization**: ~58MB (-3MB)
- **After dependency cleanup**: ~56MB (-2MB)
- **After split APKs**: ~25-30MB per APK (-30MB)
- **OR After AAB**: ~35-40MB download size (-20MB)

