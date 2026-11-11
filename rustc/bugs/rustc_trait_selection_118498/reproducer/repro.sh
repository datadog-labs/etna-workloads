#!/bin/bash
# Auto-generated from tests/ui/const-generics/ice-118285-fn-ptr-value.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
