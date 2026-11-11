#!/bin/bash
# Auto-generated from tests/ui/const-generics/generic_const_parameter_types/references-parent-generics.rs#feat
cd "$(dirname "$0")"
"$RUSTC" --cfg feat -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
