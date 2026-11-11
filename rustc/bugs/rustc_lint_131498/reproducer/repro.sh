#!/bin/bash
# Auto-generated from tests/ui/lint/non-local-defs/convoluted-locals-131474-with-mods.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
