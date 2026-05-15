#!/usr/bin/env bash
# Assemble build/package/ in kpackage6 layout from upstream + overlay.
set -euo pipefail

if [ ! -d upstream/applets/digital-clock ]; then
    git submodule update --init upstream
fi

DEST=build/package
SRC=upstream/applets/digital-clock

rm -rf "$DEST"
mkdir -p "$DEST/contents/ui" "$DEST/contents/config"

# metadata at package root
cp "$SRC/metadata.json" "$DEST/metadata.json"

# config dispatcher and schema
cp "$SRC/config.qml" "$DEST/contents/config/config.qml"
cp "$SRC/main.xml"   "$DEST/contents/config/main.xml"

# all UI QML files
cp "$SRC/main.qml"             "$DEST/contents/ui/main.qml"
cp "$SRC/DigitalClock.qml"     "$DEST/contents/ui/DigitalClock.qml"
cp "$SRC/CalendarView.qml"     "$DEST/contents/ui/CalendarView.qml"
cp "$SRC/Tooltip.qml"          "$DEST/contents/ui/Tooltip.qml"
cp "$SRC/NoTimezoneWarning.qml" "$DEST/contents/ui/NoTimezoneWarning.qml"
cp "$SRC/configAppearance.qml" "$DEST/contents/ui/configAppearance.qml"
cp "$SRC/configCalendar.qml"   "$DEST/contents/ui/configCalendar.qml"
cp "$SRC/configTimeZones.qml"  "$DEST/contents/ui/configTimeZones.qml"

# overlay applies on top (mirrors the same layout)
rsync -a overlay/ "$DEST/"

echo "Built $DEST"
