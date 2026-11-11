#!/bin/bash
# Auto-generated from tests/ui/consts/const_transmute_type_id7.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
