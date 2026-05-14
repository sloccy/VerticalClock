#!/usr/bin/env bash
# Assemble build/package/ from upstream + overlay.
set -euo pipefail

if [ ! -d upstream/applets/digital-clock ]; then
    git submodule update --init upstream
fi

DEST=build/package

rm -rf "$DEST"
mkdir -p "$DEST"

# Start with upstream applet (flat layout in current master)
rsync -a upstream/applets/digital-clock/ "$DEST/"

# Drop CMake and C++ plugin; plugin is already installed by system plasma-workspace package
rm -rf "$DEST/CMakeLists.txt" "$DEST/plugin" "$DEST/Messages.sh"

# Apply our overlay (overlay files take precedence)
rsync -a overlay/ "$DEST/"

echo "Built $DEST"
echo "  Changed files vs upstream:"
diff -rq upstream/applets/digital-clock/ "$DEST/" --exclude CMakeLists.txt --exclude plugin --exclude Messages.sh 2>/dev/null || true
