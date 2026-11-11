#!/bin/bash
"$RUSTC" --target=msp430-none-elf --emit=metadata --crate-type=lib -Zunstable-options main.rs -o out.rmeta 2>&1
echo "exit: $?"
