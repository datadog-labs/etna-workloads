#!/bin/bash
"$RUSTC" --edition 2021 --target x86_64-unknown-linux-gnu --emit=metadata -o out.rmeta main.rs 2>&1
echo "exit: $?"
