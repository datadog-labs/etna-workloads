#!/bin/bash
# Auto-generated from tests/ui/sized/unsized-str-in-return-expr-arg-and-local.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
