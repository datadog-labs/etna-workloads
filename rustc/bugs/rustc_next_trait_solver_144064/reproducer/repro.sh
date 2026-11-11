#!/bin/bash
# Auto-generated from tests/ui/sized-hierarchy/prefer-non-nested-alias-bound.rs#current
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib --cfg current --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
