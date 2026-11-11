#!/bin/bash
# Auto-generated from tests/ui/consts/slice_elem_ty_mismatch_in_unsizing_cast.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
