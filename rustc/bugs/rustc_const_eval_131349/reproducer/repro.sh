#!/bin/bash
# Auto-generated from tests/ui/consts/min_const_fn/min_const_fn_libstd_stability.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2018 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
