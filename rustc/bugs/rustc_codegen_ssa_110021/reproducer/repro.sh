#!/bin/bash
# Auto-generated from tests/codegen-llvm/intrinsics/transmute.rs
cd "$(dirname "$0")"
"$RUSTC" -Copt-level=3 -C no-prepopulate-passes --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
