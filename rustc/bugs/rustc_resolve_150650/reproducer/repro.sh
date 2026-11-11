#!/bin/bash
# Auto-generated from tests/ui/const-generics/mgca/type_const-generic-param-in-type.rs#nogate
cd "$(dirname "$0")"
"$RUSTC" --cfg nogate -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
