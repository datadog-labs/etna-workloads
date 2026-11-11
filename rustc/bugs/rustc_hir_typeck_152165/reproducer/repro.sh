#!/bin/bash
# Auto-generated from tests/ui/closures/closure-capture-hrtb-gat-no-ice-120811.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
