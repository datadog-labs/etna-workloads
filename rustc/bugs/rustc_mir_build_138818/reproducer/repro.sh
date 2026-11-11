#!/bin/bash
# Auto-generated from tests/codegen-llvm/assign-desugar-debuginfo.rs
cd "$(dirname "$0")"
"$RUSTC" -g -Zmir-opt-level=0 --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
