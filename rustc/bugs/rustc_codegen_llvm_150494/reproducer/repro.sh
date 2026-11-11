#!/bin/bash
# Auto-generated from tests/codegen-llvm/direct-access-external-data.rs#DEFAULT
cd "$(dirname "$0")"
"$RUSTC" -C relocation-model=static --cfg DEFAULT --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
