#!/bin/bash
# Auto-generated from tests/codegen-llvm/addr-of-mutate.rs
cd "$(dirname "$0")"
"$RUSTC" -C opt-level=3 -C no-prepopulate-passes --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
