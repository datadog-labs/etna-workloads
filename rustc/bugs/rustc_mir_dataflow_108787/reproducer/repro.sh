#!/bin/bash
"$RUSTC" --edition 2021 -Cpanic=abort -O -Zmir-opt-level=2 -Zvalidate-mir main.rs -o m 2>&1 | grep -E 'error|Free regions' | head -3
echo "status=${PIPESTATUS[0]}"
[ -x m ] && ./m
