#!/bin/bash
rm -rf out; mkdir -p out
"$RUSTC" --crate-type=rlib --emit=mir -Copt-level=1 -Zdump-mir=SimplifyCfg-final -Zdump-mir-dir=out -Zdump-mir-exclude-pass-number -Zmir-include-spans=false -Zmir-opt-level=4 -Zmir-enable-passes=+DeadStoreElimination-initial main.rs >/dev/null 2>&1
echo "status $?"
grep -v '^//' out/*SimplifyCfg-final.after.mir | sed -n '/bb0/,$p'
