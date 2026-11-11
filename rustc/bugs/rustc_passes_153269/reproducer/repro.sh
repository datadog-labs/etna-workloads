#!/bin/bash
# Auto-generated from tests/codegen-llvm/private-const-fn-only-used-in-const-eval.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib -Copt-level=0 --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
