#!/bin/bash
# Auto-generated from tests/ui/mir/const_eval_select_cycle.rs
cd "$(dirname "$0")"
"$RUSTC" -O --crate-type=lib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
