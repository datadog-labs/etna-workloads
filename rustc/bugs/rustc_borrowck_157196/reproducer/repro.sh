#!/bin/bash
# Auto-generated from tests/ui/borrowck/fn-closure-move-capture-no-reborrow-sugg.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib --edition 2021 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
