#!/bin/bash
"$RUSTC" --crate-type=lib --target x86_64-unknown-uefi --emit asm -O -Zunstable-options -Cpanic=abort -o out.s lib.rs 2>&1
echo "status=$?"
grep -E 'xmm|rax|rdx' out.s 2>/dev/null | sort -u
