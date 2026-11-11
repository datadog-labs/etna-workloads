#!/bin/bash
# Auto-generated from tests/ui/async-await/async-drop/assign-incompatible-types.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2024 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
