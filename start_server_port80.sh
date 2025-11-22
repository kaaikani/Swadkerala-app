#!/bin/bash

echo "🚀 Starting Redirect Server on Port 80..."
echo ""

# Check if directory exists
if [ ! -d "redirect_server" ]; then
    echo "📁 Creating redirect_server directory..."
    mkdir -p redirect_server
    cp web/universal_redirect.html redirect_server/index.html
    echo "✅ Files ready!"
fi

echo "🌐 Starting Python HTTP server on port 80..."
echo "⚠️  Note: Port 80 requires sudo privileges"
echo ""
echo "📋 Next steps:"
echo "1. Keep this terminal running"
echo "2. Open a NEW terminal"
echo "3. Run: ngrok http 80"
echo "4. Copy the HTTPS URL from ngrok"
echo "5. Update AndroidManifest.xml with the new URL"
echo ""
echo "Starting server now..."
echo ""

cd redirect_server
sudo python3 -m http.server 80









