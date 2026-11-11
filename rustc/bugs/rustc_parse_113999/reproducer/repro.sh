#!/bin/bash
# Auto-generated from tests/ui/parser/macro/macro-expand-to-field.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
