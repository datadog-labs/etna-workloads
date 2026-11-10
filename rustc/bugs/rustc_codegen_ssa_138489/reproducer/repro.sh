#!/bin/bash
"$RUSTC" --edition 2021 -Copt-level=1 -Cno-prepopulate-passes --emit=llvm-ir -o out.ll main.rs 2>&1 | head -5
echo "exit $?"
grep -c 'llvm.lifetime.start' out.ll
grep -c 'llvm.lifetime.end' out.ll
