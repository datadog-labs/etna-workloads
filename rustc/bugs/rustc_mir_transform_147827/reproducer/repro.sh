#!/bin/bash
# Auto-generated from tests/codegen-llvm/maybeuninit-array.rs
cd "$(dirname "$0")"
"$RUSTC" -Copt-level=3 --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
