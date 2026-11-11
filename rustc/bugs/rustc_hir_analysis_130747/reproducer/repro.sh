#!/bin/bash
"$RUSTC" -Awarnings --target thumbv8m.main-none-eabi --crate-type lib --emit=metadata -o out.rmeta main.rs 2>&1
echo "exit: $?"
