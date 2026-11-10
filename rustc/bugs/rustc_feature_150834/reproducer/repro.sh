#!/bin/bash
# Auto-generated from tests/ui/feature-gates/feature-gate-multiple_supertrait_upcastable.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
