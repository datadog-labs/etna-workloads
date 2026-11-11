#!/bin/bash
# Auto-generated from tests/ui/consts/erroneous_type_in_const_return_value.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
