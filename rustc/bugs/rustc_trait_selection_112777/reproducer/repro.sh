#!/bin/bash
# Auto-generated from tests/ui/type-alias-impl-trait/debug-ty-with-weak.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib -Cdebuginfo=2 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
