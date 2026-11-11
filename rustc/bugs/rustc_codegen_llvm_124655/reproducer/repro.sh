#!/bin/bash
# Auto-generated from tests/ui/abi/fixed_x18.rs#arm
cd "$(dirname "$0")"
"$RUSTC" -Zfixed-x18 --target=armv7-unknown-linux-gnueabihf --crate-type=rlib --cfg arm -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
