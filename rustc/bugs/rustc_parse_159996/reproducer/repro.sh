#!/bin/bash
# Auto-generated from tests/ui/parser/macro/do-not-suggest-semicolon-between-macro-without-exclamation-mark-and-array.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
