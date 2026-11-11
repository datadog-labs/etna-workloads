#!/bin/bash
# Auto-generated from tests/ui/const-generics/generic_const_exprs/const_kind_expr/relate_ty_with_infer_1.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
