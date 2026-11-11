#!/bin/bash
# Auto-generated from tests/ui/consts/const-eval/c-variadic-ignored-argument.rs
cd "$(dirname "$0")"
"$RUSTC" --emit=obj -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
