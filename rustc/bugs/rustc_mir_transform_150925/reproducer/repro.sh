#!/bin/bash
"$RUSTC" --crate-type=lib --edition=2021 -O -Zmir-opt-level=2 -Zdump-mir=SimplifyComparisonIntegral -Zdump-mir-dir=d main.rs 2>&1
echo "exit $?"
grep -h "switchInt" d/main.f.*SimplifyComparisonIntegral.after.mir
rm -rf d
