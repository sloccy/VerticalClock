#!/usr/bin/env bash
# Manually bump the upstream submodule, then build to verify.
set -euo pipefail

OLD=$(git -C upstream rev-parse HEAD)
git -C upstream fetch --depth=1 origin master
git -C upstream checkout origin/master
NEW=$(git -C upstream rev-parse HEAD)

if [ "$OLD" = "$NEW" ]; then
    echo "Already at latest ($NEW). Nothing to do."
    exit 0
fi

echo "Bumped: $OLD → $NEW"
scripts/check-anchors.sh || { echo "WARN: anchor check failed — review overlay before committing."; }
scripts/build.sh

git add upstream
git commit -m "Bump upstream plasma-workspace to ${NEW:0:12}"
echo "Done. Test with: scripts/deploy.sh"
