#!/bin/bash
# Auto-generated from tests/ui/consts/const-eval/simd/simd-packed-non-pow2.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
