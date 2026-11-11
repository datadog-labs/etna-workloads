#!/bin/bash
# Auto-generated from tests/ui/auto-traits/typeck-default-trait-impl-precedence.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
