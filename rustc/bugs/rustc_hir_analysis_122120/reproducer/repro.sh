#!/bin/bash
# Auto-generated from tests/ui/associated-type-bounds/suggest-assoc-ty-bound-on-eq-bound.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
