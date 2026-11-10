#!/bin/bash
"$RUSTC" --edition 2021 -Copt-level=3 -Zinline-mir -Zdump-mir=caller -Zdump-mir-dir=dump --crate-type bin main.rs -o out 2>&1 | head -20
echo "status ${PIPESTATUS[0]}"
echo "dumps with inlined callee scope:"
grep -l 'inlined callee' dump/*caller*Inline.after.mir 2>/dev/null | wc -l
