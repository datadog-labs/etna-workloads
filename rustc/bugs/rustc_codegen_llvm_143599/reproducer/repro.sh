#!/bin/bash
# Auto-generated from tests/assembly-llvm/emit-intel-att-syntax.rs#intel
cd "$(dirname "$0")"
"$RUSTC" -Cllvm-args=-x86-asm-syntax=intel --cfg intel --emit=asm -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
