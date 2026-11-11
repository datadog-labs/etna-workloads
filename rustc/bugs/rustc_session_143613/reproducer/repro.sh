#!/bin/bash
"$RUSTC" --crate-type=lib --emit=asm -C panic=abort -C opt-level=1 -o out.s main.rs 2>&1
echo "status=$?"
if grep -q '\.cfi_startproc' out.s; then echo "unwind tables: yes"; else echo "unwind tables: no"; fi
