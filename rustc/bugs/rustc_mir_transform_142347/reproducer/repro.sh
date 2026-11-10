#!/bin/bash
# Auto-generated from tests/ui/async-await/async-drop/live-dead-storage3.rs
cd "$(dirname "$0")"
"$RUSTC" -Zlint-mir --crate-type lib --edition 2024 --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
