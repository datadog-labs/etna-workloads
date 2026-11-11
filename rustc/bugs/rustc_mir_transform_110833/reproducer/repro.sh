#!/bin/bash
# Auto-generated from tests/mir-opt/inline/dont_ice_on_generic_rust_call.rs
cd "$(dirname "$0")"
"$RUSTC" -Zmir-enable-passes=+Inline --crate-type=lib -Zmir-opt-level=1 --emit=mir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
