#!/bin/bash
# Auto-generated from tests/ui/traits/const-traits/non-const-op-const-closure-non-const-outer.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
