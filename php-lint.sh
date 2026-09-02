#!/usr/bin/env bash
#
# Lint every PHP file under a directory, skipping vendor and node_modules.
#
set -uo pipefail

DIR="${INPUT_PLUGIN_DIR:-.}"
echo "Linting PHP files under: $DIR"

fail=0
count=0
while IFS= read -r -d '' f; do
	count=$((count + 1))
	if ! out="$(php -l "$f" 2>&1)"; then
		echo "::error file=${f}::${out}"
		fail=1
	fi
done < <(find "$DIR" -name '*.php' -not -path '*/vendor/*' -not -path '*/node_modules/*' -print0)

echo "Checked ${count} PHP file(s)."
if [ "$fail" -ne 0 ]; then
	echo "::error::PHP lint failed."
	exit 1
fi
echo "PHP lint passed."
