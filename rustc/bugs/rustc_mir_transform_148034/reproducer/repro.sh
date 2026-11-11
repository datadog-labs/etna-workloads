#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib -O -Zmir-opt-level=2 --emit=mir -o out.mir main.rs 2>&1
echo "status $?"
grep -E 'assume|discriminant' out.mir
