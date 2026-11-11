#!/bin/bash
# Auto-generated from tests/ui/const-generics/adt_const_params/116308.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
