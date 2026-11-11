#!/bin/bash
# Auto-generated from tests/ui/const-generics/generic_const_exprs/type-alias-bounds.rs#pos
cd "$(dirname "$0")"
"$RUSTC" --cfg pos --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
