#!/usr/bin/env bash
# Run this on the Fedora machine to install or update the widget.
# Requires: kpackagetool6 (ships with plasma-workspace)
set -euo pipefail

REPO="sloccy/VerticalClock"
URL="https://github.com/$REPO/releases/latest/download/verticalclock.zip"
TMP=$(mktemp -d)

echo "Downloading latest build..."
curl -fL "$URL" -o "$TMP/verticalclock.zip"

echo "Installing..."
kpackagetool6 -t Plasma/Applet -u "$TMP/verticalclock.zip" \
  || kpackagetool6 -t Plasma/Applet -i "$TMP/verticalclock.zip"

rm -rf "$TMP"
echo "Done. Restart plasmashell or re-login to pick up changes."
