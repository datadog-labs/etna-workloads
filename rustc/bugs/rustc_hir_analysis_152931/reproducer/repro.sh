#!/bin/bash
# Auto-generated from tests/ui/const-generics/check_const_arg_type_in_free_alias.rs#eager
cd "$(dirname "$0")"
"$RUSTC" --cfg eager -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
