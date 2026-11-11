#!/bin/bash
# Auto-generated from tests/codegen-llvm/intrinsics/volatile.rs
cd "$(dirname "$0")"
"$RUSTC" -C no-prepopulate-passes --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
