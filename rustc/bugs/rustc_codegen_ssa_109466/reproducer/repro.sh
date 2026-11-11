#!/bin/bash
# Auto-generated from tests/codegen-llvm/inline-function-args-debug-info.rs
cd "$(dirname "$0")"
"$RUSTC" -Zinline-mir=yes -Cdebuginfo=2 --edition 2021 --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
