#!/bin/bash
"$RUSTC" --target riscv32e-unknown-none-elf --emit=asm -o out.s main.rs 2>&1 | sed 's/-->.*/-->/'
echo "status=${PIPESTATUS[0]}"
