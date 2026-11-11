#!/bin/bash
# Auto-generated from tests/ui/const-generics/const-ty-is-normalized.rs
cd "$(dirname "$0")"
"$RUSTC" -Cdebuginfo=2 --crate-type=lib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
