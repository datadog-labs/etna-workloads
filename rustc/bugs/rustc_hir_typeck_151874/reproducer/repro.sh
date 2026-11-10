#!/bin/bash
# Auto-generated from tests/ui/const-generics/adt_const_params/unsized-anon-const-err-1.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
