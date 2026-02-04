#!/bin/bash
# Fetch GraphQL schema from shop-api and generate Dart files.
# Usage: ./scripts/fetch_schema_from_shop_api.sh
# Requires: Node.js (for npx get-graphql-schema) and Dart (for build_runner).
#
# Set SHOP_API_URL in .env or pass as env, e.g.:
#   SHOP_API_URL=http://192.168.31.15/shop-api ./scripts/fetch_schema_from_shop_api.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SCHEMA_FILE="$PROJECT_DIR/lib/graphql/schema.graphql"

# Load .env if present
if [ -f "$PROJECT_DIR/.env" ]; then
  export $(grep -v '^#' "$PROJECT_DIR/.env" | xargs)
fi

SHOP_API_URL="${SHOP_API_URL:-http://192.168.31.15/shop-api}"
echo "Using SHOP_API_URL: $SHOP_API_URL"

# Fetch schema (SDL) using get-graphql-schema
if command -v npx &> /dev/null; then
  echo "Fetching schema from $SHOP_API_URL ..."
  npx --yes get-graphql-schema "$SHOP_API_URL" > "$SCHEMA_FILE"
  echo "Schema written to lib/graphql/schema.graphql"
else
  echo "Error: npx not found. Install Node.js and try again."
  echo "Alternatively, run manually:"
  echo "  npx get-graphql-schema $SHOP_API_URL > lib/graphql/schema.graphql"
  exit 1
fi

# Generate Dart files
echo "Running build_runner to generate GraphQL Dart files..."
cd "$PROJECT_DIR"
dart run build_runner build --delete-conflicting-outputs
echo "Done. Schema and generated files are ready."
