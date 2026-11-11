#!/bin/bash
"$RUSTC" --crate-type=lib --emit=llvm-ir -Copt-level=3 -Ctarget-feature=-avx2 -o out.ll lib.rs 2>&1
echo "status $?"
grep -o '"target-features"="[^"]*"' out.ll
