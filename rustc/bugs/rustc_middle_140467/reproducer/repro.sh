#!/bin/bash
# Auto-generated from tests/ui/const-generics/const_eval_unchecked_doesnt_fire_patterns.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
