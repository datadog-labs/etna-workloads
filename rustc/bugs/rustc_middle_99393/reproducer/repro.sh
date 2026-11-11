#!/bin/bash
# Auto-generated from tests/ui/array-slice-vec/match_arr_unknown_len.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
