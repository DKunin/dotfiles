#!/usr/bin/env bash
#
# update-npm-package.sh
# A simple script to update an npm package to its latest version.
# Usage: ./update-npm-package.sh <package-name> [--global]
#

set -euo pipefail

PACKAGE="$1"
GLOBAL_FLAG=""
# If the second argument is "--global", we'll update the package globally
if [[ "${2-}" == "--global" ]]; then
  GLOBAL_FLAG="-g"
fi

echo "🌱 Checking current version of $PACKAGE..."
npm list ${GLOBAL_FLAG} "$PACKAGE" --depth=0 || echo "(not installed yet)"

echo "🚀 Installing $PACKAGE@latest ${GLOBAL_FLAG} ..."
npm install ${GLOBAL_FLAG} "$PACKAGE@latest"

echo "🎉 $PACKAGE was updated to:"
npm list ${GLOBAL_FLAG} "$PACKAGE" --depth=0

echo "✅ Done!"
