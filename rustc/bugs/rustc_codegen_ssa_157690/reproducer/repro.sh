#!/bin/bash
"$RUSTC" --edition 2021 --emit=llvm-ir -Cno-prepopulate-passes -Copt-level=0 --target x86_64-unknown-linux-gnu main.rs -o out.ll 2>&1
echo "status $?"
grep -E 'store i(16|64)' out.ll | sed 's/!.*//'
