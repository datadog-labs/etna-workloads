#!/bin/bash
"$RUSTC" --target riscv64gc-unknown-linux-gnu --emit=llvm-ir -o out.ll main.rs 2>&1
echo "status $?"
grep target-abi out.ll || echo "no target-abi flag"
