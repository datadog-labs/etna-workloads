#!/bin/bash
export RUSTC_BOOTSTRAP=1
$RUSTC --edition 2021 --crate-type lib --emit=mir -Zmir-opt-level=0 -Zmir-enable-passes=+GVN -Zdump-mir=repeat_place -Zdump-mir-dir=dump main.rs -o out.mir >/dev/null 2>&1
echo "status $?"
f=$(ls dump | grep 'repeat_place.*GVN.after.mir' | head -1)
grep -E '_0 = |_[0-9]+ = &|_1 = ' "dump/$f"
