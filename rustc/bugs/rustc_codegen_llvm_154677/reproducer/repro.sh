#!/bin/bash
$RUSTC --target aarch64-unknown-linux-gnu -Zsanitizer=hwaddress -Copt-level=0 --emit=llvm-ir -o out.ll main.rs 2>&1
echo "status $?"
grep -o '"target-features"="[^"]*"' out.ll | sort -u
