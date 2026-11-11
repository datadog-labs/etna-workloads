#!/bin/bash
# Auto-generated from tests/ui/contracts/async-fn-contract-ice-145333.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib --edition 2021 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
