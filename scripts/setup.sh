#!/usr/bin/env bash
# Run once after git init + before first build.
set -euo pipefail

git submodule add https://invent.kde.org/plasma/plasma-workspace.git upstream
git -C upstream sparse-checkout init --cone
git -C upstream sparse-checkout set applets/digital-clock
git -C upstream checkout
git add .gitmodules upstream
git commit -m "Add plasma-workspace as sparse submodule"
echo "Done. Run: scripts/build.sh"
