#!/bin/bash
# Auto-generated from tests/mir-opt/inline_default_trait_body.rs
cd "$(dirname "$0")"
"$RUSTC" -Zinline-mir --crate-type=lib --edition 2021 -Zmir-opt-level=1 --emit=mir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
