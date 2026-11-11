#!/bin/bash
# Auto-generated from tests/ui/generics/missing-param-but-has-colon-144215.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
