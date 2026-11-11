#!/bin/bash
# Auto-generated from tests/ui/type-alias-impl-trait/mututally-recursive-overflow.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
