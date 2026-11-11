#!/bin/bash
"$RUSTC" --edition 2021 -O -Zmir-opt-level=2 --emit=mir -o out.mir main.rs 2>&1
echo "status $?"
grep -v '^//' out.mir | grep -E '\[(_[0-9]+|[0-9]+ of [0-9]+)\]' | sed 's/_[0-9]*/_N/g'
