#!/bin/bash
# Auto-generated from tests/mir-opt/otherwise_drops.rs
cd "$(dirname "$0")"
"$RUSTC" -C panic=abort --crate-type=lib -Zmir-opt-level=1 --emit=mir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
