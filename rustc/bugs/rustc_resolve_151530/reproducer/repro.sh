#!/bin/bash
# Auto-generated from tests/ui/lifetimes/mut-ref-owned-suggestion.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
