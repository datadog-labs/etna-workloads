#!/bin/bash
"$RUSTC" --target loongarch64-unknown-linux-gnu --emit=llvm-ir -Copt-level=0 -Awarnings -o out.ll main.rs 2>&1
echo "status $?"
grep -E '^define|load \{|load float|load double|load i8|memcpy' out.ll | sed 's/#[0-9]*//'
