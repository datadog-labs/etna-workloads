#!/bin/bash
# Auto-generated from tests/ui/typeck/method-chain-gats.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
