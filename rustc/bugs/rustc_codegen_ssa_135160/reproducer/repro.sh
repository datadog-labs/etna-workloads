#!/bin/bash
"$RUSTC" --crate-type=lib --target=aarch64-unknown-none-softfloat --emit=metadata -o out.rmeta main.rs 2>&1
echo "exit: $?"
