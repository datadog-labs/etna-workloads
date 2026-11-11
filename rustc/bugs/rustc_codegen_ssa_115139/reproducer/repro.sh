#!/bin/bash
# Auto-generated from tests/codegen-llvm/sroa-fragment-debuginfo.rs
cd "$(dirname "$0")"
"$RUSTC" -g -Zmir-opt-level=0 -Zmir-enable-passes=+ScalarReplacementOfAggregates -Cno-prepopulate-passes --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
