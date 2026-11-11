#!/bin/bash
rm -rf d
$RUSTC --edition 2021 --crate-type lib --emit=mir -Zmir-opt-level=1 -Zmir-enable-passes=+GVN -Zdump-mir=overlapping -Zdump-mir-dir=d -o out.mir main.rs >/dev/null 2>&1
echo "status $?"
grep -hE '^ *\(\*_2\) =' d/*overlapping*GVN.after.mir
rm -rf d out.mir
