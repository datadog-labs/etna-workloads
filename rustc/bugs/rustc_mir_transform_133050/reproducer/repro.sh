#!/bin/bash
# Auto-generated from tests/codegen-llvm/float/f16-f128-inline.rs#default
cd "$(dirname "$0")"
"$RUSTC" --cfg default --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
