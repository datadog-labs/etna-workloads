#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib -Copt-level=1 -Zmir-opt-level=2 -Zdump-mir=SimplifyComparisonIntegral -Zdump-mir-dir=d main.rs -o m.rlib 2>&1; echo "compile=$?"
f=$(ls d/*main.f.*SimplifyComparisonIntegral.after.mir 2>/dev/null | head -1)
grep -E 'Eq\(|nop|switchInt' "$f"
