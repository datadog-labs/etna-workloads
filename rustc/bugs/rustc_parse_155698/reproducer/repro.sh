#!/bin/bash
# Auto-generated from tests/ui/parser/struct-expr-pat-tuple-index-shorthand.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
