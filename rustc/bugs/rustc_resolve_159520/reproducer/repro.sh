#!/bin/bash
# Auto-generated from tests/ui/resolve/suggestions/suggest-vec-not-slice.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
