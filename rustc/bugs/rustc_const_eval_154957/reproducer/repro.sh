#!/bin/bash
# Auto-generated from tests/ui/traits/const-traits/const-closure-in-non-const-trait-impl-method.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
