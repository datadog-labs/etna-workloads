#!/bin/bash
# Auto-generated from tests/codegen-llvm/debug-vtable.rs#NONMSVC
cd "$(dirname "$0")"
"$RUSTC" -Cdebuginfo=2 -Copt-level=0 -Csymbol-mangling-version=v0 --cfg NONMSVC --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
