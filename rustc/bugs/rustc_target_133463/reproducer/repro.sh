#!/bin/bash
RUSTC_BOOTSTRAP=1 $RUSTC --target aarch64-unknown-linux-gnu -Zfixed-x18 --emit=llvm-ir -O -Awarnings -o out.ll main.rs 2>&1 | grep -v "^warning\|^ *|\|^ *=\|^$" | head -20
echo "status ${PIPESTATUS[0]}"
grep -o "={w17},[^,]*," out.ll | head -1
