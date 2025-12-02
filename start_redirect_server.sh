#!/bin/bash

# Script to start the redirect server for deep links

echo "🚀 Starting Universal Redirect Server..."
echo ""

# Create directory if it doesn't exist
mkdir -p ngrok_server

# Copy redirect file
cp web/universal_redirect.html ngrok_server/index.html

echo "✅ Redirect file copied to ngrok_server/index.html"
echo ""
echo "📋 Next steps:"
echo ""
echo "1. Start the server (this terminal):"
echo "   cd ngrok_server"
echo "   python3 -m http.server 8000"
echo ""
echo "2. In a NEW terminal, start ngrok:"
echo "   ngrok http 8000"
echo ""
echo "3. Copy the ngrok HTTPS URL (e.g., https://abc123.ngrok-free.app)"
echo ""
echo "4. Update android/app/src/main/AndroidManifest.xml:"
echo "   Replace '63f4005bb018.ngrok-free.app' with your new ngrok URL"
echo ""
echo "5. Rebuild and reinstall app:"
echo "   flutter build apk --debug"
echo "   adb install -r build/app/outputs/flutter-apk/app-debug.apk"
echo ""
echo "6. Test: Open https://YOUR_NGROK_URL.ngrok-free.app/cart in browser"
echo ""
echo "Starting server now..."
echo ""

cd ngrok_server
python3 -m http.server 8000










