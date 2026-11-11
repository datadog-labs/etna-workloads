#!/bin/bash
# Auto-generated from tests/ui/parser/bounds-type.rs
cd "$(dirname "$0")"
"$RUSTC" -Z parse-crate-root-only --edition 2021 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
