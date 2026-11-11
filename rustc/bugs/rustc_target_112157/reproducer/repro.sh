#!/bin/bash
$RUSTC --target aarch64-unknown-linux-gnu --emit=llvm-ir -O -o out.ll main.rs 2>&1
echo "status $?"
grep -E 'define.*test_16' out.ll | sed 's/ #.*//'
