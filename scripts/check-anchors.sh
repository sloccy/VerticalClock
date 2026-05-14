#!/usr/bin/env bash
# Verify overlay-anchors.txt: each listed string must still exist in upstream.
# Exit non-zero if any anchor is missing (overlay needs manual review).
set -euo pipefail

APPLET_DIR="upstream/applets/digital-clock"
fail=0

while IFS=$'\t' read -r file pattern; do
    [[ -z "$file" || "$file" == \#* ]] && continue
    if ! grep -qF "$pattern" "$APPLET_DIR/$file"; then
        echo "MISSING anchor in $file: $pattern" >&2
        fail=1
    fi
done < overlay-anchors.txt

if [ "$fail" -eq 0 ]; then
    echo "Anchor check passed."
else
    echo "Anchor check FAILED — overlay may need updating." >&2
fi
exit $fail
