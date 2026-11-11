#!/bin/bash
# Auto-generated from tests/codegen-llvm/debuginfo-cyclic-structure.rs
cd "$(dirname "$0")"
"$RUSTC" -g -Copt-level=0 -C panic=abort --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
