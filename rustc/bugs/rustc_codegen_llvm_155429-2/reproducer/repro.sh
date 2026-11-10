#!/bin/bash
# Emit asm for an i128 va_arg read on aarch64-pc-windows-msvc.
$RUSTC --edition 2021 --target aarch64-pc-windows-msvc --crate-type lib -Copt-level=3 main.rs --emit asm -o out.s 2>&1 | grep -E '^error' | head
echo "status ${PIPESTATUS[0]}"
sed -n '/^read_i128:/,/ret/p' out.s
