#!/usr/bin/env bash
# Build and deploy to the Fedora KDE machine.
# Set VCLOCK_HOST before calling, e.g.: VCLOCK_HOST=user@fedora-box scripts/deploy.sh
set -euo pipefail

HOST="${VCLOCK_HOST:?set VCLOCK_HOST=user@fedora-box}"
REMOTE_DIR="VerticalClock-pkg"

scripts/build.sh

rsync -az --delete build/package/ "$HOST:$REMOTE_DIR/"

ssh "$HOST" "kpackagetool6 -t Plasma/Applet -u '$REMOTE_DIR' \
             || kpackagetool6 -t Plasma/Applet -i '$REMOTE_DIR'"

echo "Restarting plasmashell on $HOST..."
ssh "$HOST" "kquitapp6 plasmashell; setsid kstart plasmashell >/dev/null 2>&1 &"
echo "Deploy complete."
