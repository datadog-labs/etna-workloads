#!/bin/bash
# Auto-generated from tests/ui/typeck/suggest-method-name-with-maybe-ty-mismatch-146008.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
