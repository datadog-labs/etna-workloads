#!/bin/bash
# Auto-generated from tests/ui/imports/suggest-import-ice-issue-127302.rs#edition2015
cd "$(dirname "$0")"
"$RUSTC" --cfg edition2015 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
