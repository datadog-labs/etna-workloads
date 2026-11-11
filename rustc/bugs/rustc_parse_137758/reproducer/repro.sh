#!/bin/bash
# Auto-generated from tests/ui/attributes/decl_macro_ty_in_attr_macro.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
