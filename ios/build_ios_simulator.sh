#!/bin/bash
# Build iOS for simulator (and optionally install + run on a simulator).
# Run from project root: ./ios/build_ios_simulator.sh [simulator_id]
# Example: ./ios/build_ios_simulator.sh A038C20C-1B93-49AE-AB8C-C8C87801CBE8
set -e
cd "$(dirname "$0")/.."
export LANG=en_US.UTF-8
APP_PATH="build/ios/Debug-iphonesimulator/Runner.app"
BUNDLE_ID="com.example.untitled2"

flutter pub get
cd ios
pod install
# Build with CLANG_ALLOW_NON_MODULAR_INCLUDES so Firebase pods compile
xcodebuild -configuration Debug -quiet -workspace Runner.xcworkspace -scheme Runner \
  "BUILD_DIR=$(pwd)/../build/ios" -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  FLUTTER_SUPPRESS_ANALYTICS=true COMPILER_INDEX_STORE_ENABLE=NO \
  CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES=YES \
  build
echo "Build succeeded. App: $APP_PATH"

# Install and launch on simulator if one is specified or booted
SIM_ID="${1:-}"
if [ -z "$SIM_ID" ]; then
  SIM_ID=$(xcrun simctl list devices booted 2>/dev/null | grep -o '[A-F0-9-]\{36\}' | head -1)
fi
if [ -n "$SIM_ID" ] && [ -d "../$APP_PATH" ]; then
  echo "Installing and launching on simulator $SIM_ID..."
  xcrun simctl install "$SIM_ID" "../$APP_PATH"
  xcrun simctl launch "$SIM_ID" "$BUNDLE_ID"
  echo "App launched."
else
  echo "To run on simulator: flutter run -d <id> may fail; use: xcrun simctl install <sim_id> $APP_PATH && xcrun simctl launch <sim_id> $BUNDLE_ID"
fi
