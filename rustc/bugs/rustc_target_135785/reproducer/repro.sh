#!/bin/bash
$RUSTC --target s390x-unknown-linux-gnu -C target-cpu=z13 --emit=llvm-ir -C opt-level=1 -C no-prepopulate-passes -o out.ll main.rs 2>&1 | grep -E "^error" 
echo "status ${PIPESTATUS[0]}"
grep -E '^define' out.ll
