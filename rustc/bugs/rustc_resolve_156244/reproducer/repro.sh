#!/bin/bash
# Auto-generated from tests/ui/imports/private-import-suggestion-path-156244.rs#edition_2015
cd "$(dirname "$0")"
"$RUSTC" --edition 2015 --cfg edition_2015 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
