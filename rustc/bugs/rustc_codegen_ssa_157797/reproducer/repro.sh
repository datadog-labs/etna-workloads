#!/bin/bash
# Auto-generated from tests/codegen-llvm/uninit-aggregate-field.rs
cd "$(dirname "$0")"
"$RUSTC" -C no-prepopulate-passes -C opt-level=2 --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
