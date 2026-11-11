#!/bin/bash
# Auto-generated from tests/ui/const-generics/mgca/wrong_type_const_arr_diag.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
