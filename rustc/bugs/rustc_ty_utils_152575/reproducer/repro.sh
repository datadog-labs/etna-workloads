#!/bin/bash
# Auto-generated from tests/ui/layout/rigid-alias-due-to-broken-impl.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=rlib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
