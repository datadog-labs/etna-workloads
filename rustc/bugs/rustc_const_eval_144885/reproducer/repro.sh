#!/bin/bash
# Auto-generated from tests/ui/consts/ptr_comparisons.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib --edition 2024 --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
