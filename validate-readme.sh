#!/usr/bin/env bash
#
# Validate the structure of a WordPress readme.txt: required headers,
# a Changelog section, and a short description within the length limit.
#
set -uo pipefail

README="${INPUT_README:-readme.txt}"
if [ ! -f "$README" ]; then
	echo "::error::readme.txt not found at ${README}"
	exit 1
fi

fail=0
check() {
	local label="$1" regex="$2"
	if grep -qiE "$regex" "$README"; then
		echo "ok: ${label}"
	else
		echo "::error::readme.txt is missing: ${label}"
		fail=1
	fi
}

check "plugin name header (=== Name ===)" '^===[[:space:]]*[^=].*==='
check "Stable tag"        '^[[:space:]]*Stable tag:[[:space:]]*[0-9A-Za-z._-]+'
check "Requires at least" '^[[:space:]]*Requires at least:[[:space:]]*[0-9.]+'
check "Tested up to"      '^[[:space:]]*Tested up to:[[:space:]]*[0-9.]+'
check "License"           '^[[:space:]]*License:[[:space:]]*.+'
check "Changelog section" '^==[[:space:]]*Changelog[[:space:]]*=='

# Short description: the first non-empty line after the header block.
short="$(awk '
	/^===/            { inheader = 1; next }
	inheader && /^[[:space:]]*$/ { inheader = 0; next }
	inheader          { next }
	/^[[:space:]]*$/   { next }
	                  { print; exit }
' "$README")"
len=${#short}
if [ "$len" -gt 150 ]; then
	echo "::warning::Short description is ${len} characters; WordPress.org recommends 150 or fewer."
elif [ "$len" -eq 0 ]; then
	echo "::warning::No short description found after the header block."
else
	echo "ok: short description (${len} chars)"
fi

if [ "$fail" -ne 0 ]; then
	echo "::error::readme.txt validation failed."
	exit 1
fi
echo "readme.txt looks valid."
