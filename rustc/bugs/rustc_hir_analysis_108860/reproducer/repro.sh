#!/bin/bash
# Auto-generated from tests/ui/type-alias-impl-trait/bounds-are-checked3.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
