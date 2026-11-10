#!/bin/bash
$RUSTC --target riscv64gc-unknown-linux-gnu --emit=llvm-ir -C opt-level=0 -o out.ll main.rs 2>&1
echo "status $?"
grep -E '^define' out.ll | sed 's/#[0-9]*//'
grep -E 'load|store|memcpy' out.ll | sed 's/!.*//'
