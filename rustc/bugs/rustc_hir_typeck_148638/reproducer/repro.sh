#!/bin/bash
# Auto-generated from tests/ui/asm/invalid-repr-simd-on-enum-148634.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
