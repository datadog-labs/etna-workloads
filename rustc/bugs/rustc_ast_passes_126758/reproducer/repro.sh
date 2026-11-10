#!/bin/bash
# Auto-generated from tests/ui/rust-2024/safe-outside-extern.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
