#!/bin/bash
# Auto-generated from tests/codegen-llvm/const-array-of-pairs.rs
cd "$(dirname "$0")"
"$RUSTC" -O -C no-prepopulate-passes --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
