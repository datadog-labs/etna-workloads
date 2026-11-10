#!/bin/bash
# Auto-generated from tests/ui/const-generics/generic_const_exprs/const-block-is-poly.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
