#!/bin/bash
# Auto-generated from tests/ui/const-generics/mgca/cyclic-type-const-151251.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
