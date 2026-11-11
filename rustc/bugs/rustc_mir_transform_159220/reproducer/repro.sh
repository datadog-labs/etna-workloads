#!/bin/bash
rm -rf mir_dump
"$RUSTC" --crate-type=lib -Zlint-mir=false -Zmir-opt-level=2 -Copt-level=1 -Zmir-enable-passes=-GVN,-CopyProp -Zdump-mir=SimplifyComparisonIntegral -Zdump-mir-dir=mir_dump main.rs >/dev/null 2>&1
echo "status $?"
cat mir_dump/*SimplifyComparisonIntegral.after.mir | grep -vE "^//"
rm -rf mir_dump
