#!/bin/bash
# Auto-generated from tests/ui/sized-hierarchy/pretty-print-opaque-no-feat.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
