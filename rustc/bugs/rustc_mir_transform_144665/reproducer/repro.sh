#!/bin/bash
"$RUSTC" --edition 2021 -C opt-level=1 --emit=mir -o out.mir main.rs > log.txt 2>&1
echo "status $?"
grep -o "Projecting into SIMD type.*" log.txt | head -1
