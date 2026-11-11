#!/bin/bash
# Auto-generated from tests/ui/async-await/async-drop/async-drop-future-drop-poll.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib --edition 2024 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
