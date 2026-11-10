#!/bin/bash
"$RUSTC" --target wasm32-wasip1 -Copt-level=3 --emit=llvm-ir -o out.ll main.rs 2>&1
echo "status $?"
grep -E '^define.*@ret' out.ll | grep -c sret
