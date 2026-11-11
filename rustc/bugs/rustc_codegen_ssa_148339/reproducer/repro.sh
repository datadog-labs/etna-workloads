#!/bin/bash
$RUSTC --edition 2021 --crate-type lib -O --emit asm -o out.s main.rs 2>&1 | grep -v '^$' | head -5
echo "status ${PIPESTATUS[0]}"
grep -c -E '\.globl|\.hidden|\.local' out.s 2>/dev/null
grep -E '\.globl|\.hidden|\.local' out.s 2>/dev/null | sed 's/_R[A-Za-z0-9_]*/SYM/'
