#!/bin/bash
# Auto-generated from tests/ui/imports/suggest-import-issue-120074.rs#edition2015
cd "$(dirname "$0")"
"$RUSTC" --edition 2015 --cfg edition2015 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
