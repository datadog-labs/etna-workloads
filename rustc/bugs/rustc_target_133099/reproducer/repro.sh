#!/bin/bash
"$RUSTC" --target x86_64-unknown-linux-gnu -Ctarget-feature=-x87 --crate-type=lib --emit=metadata -o out.rmeta main.rs 2>&1
echo "exit=$?"
