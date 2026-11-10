#!/bin/bash
"$RUSTC" --target loongarch64-unknown-none-softfloat --emit=asm -o out.s main.rs 2>&1
echo "status $?"
