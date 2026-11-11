#!/bin/bash
"$RUSTC" --target aarch64-unknown-linux-gnu --emit=llvm-ir -Copt-level=0 -Ctarget-feature=-sve -o out.ll main.rs 2>&1 | grep -c '^error'
grep -o '"target-features"="[^"]*"' out.ll
