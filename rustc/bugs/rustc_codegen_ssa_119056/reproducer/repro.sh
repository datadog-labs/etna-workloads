#!/bin/bash
# Auto-generated from tests/codegen-llvm/overaligned-constant.rs
cd "$(dirname "$0")"
"$RUSTC" -Zmir-opt-level=0 -Zmir-enable-passes=+GVN -Cno-prepopulate-passes --crate-type=lib --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
