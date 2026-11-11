#!/bin/bash
# Auto-generated from tests/codegen-llvm/naked-fn/aligned.rs
cd "$(dirname "$0")"
"$RUSTC" -C no-prepopulate-passes -Copt-level=0 --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
