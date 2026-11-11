#!/bin/bash
# Auto-generated from tests/ui/explain/overflow-error-code.rs
cd "$(dirname "$0")"
"$RUSTC" --explain E10000 --crate-type=lib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
