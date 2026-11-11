#!/bin/bash
# Auto-generated from tests/ui/imports/underscore-imports/invalid-path-110164.rs#ed2015
cd "$(dirname "$0")"
"$RUSTC" --edition 2015 --cfg ed2015 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
