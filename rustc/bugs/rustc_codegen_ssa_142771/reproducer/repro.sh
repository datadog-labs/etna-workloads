#!/bin/bash
# Auto-generated from tests/codegen-llvm/debuginfo-dse.rs#CODEGEN
cd "$(dirname "$0")"
"$RUSTC" -Copt-level=3 -g -Zverify-llvm-ir -Zmerge-functions=disabled -Cno-prepopulate-passes --cfg CODEGEN --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
