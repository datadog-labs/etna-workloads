#!/bin/bash
# Auto-generated from tests/ui/const-generics/mistyped_const_in_pat.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
