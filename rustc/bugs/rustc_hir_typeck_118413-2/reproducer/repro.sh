#!/bin/bash
"$RUSTC" --edition 2021 --crate-type bin --emit=metadata -o out.rmeta main.rs 2>&1
echo "exit: $?"
