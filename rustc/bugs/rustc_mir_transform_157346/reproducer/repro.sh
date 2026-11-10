#!/bin/bash
"$RUSTC" --crate-type=bin --edition 2021 -Copt-level=1 -Zmir-opt-level=2 --emit=mir -Zdump-mir=field_borrow -Zdump-mir-dir=d main.rs 2>&1
f=$(ls d/*field_borrow*GVN.after.mir | head -1)
grep -E '_[0-9]+ = ' "$f" | sed 's/ *\/\/.*//'
