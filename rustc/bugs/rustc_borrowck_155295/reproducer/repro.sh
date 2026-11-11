#!/bin/bash
# Auto-generated from tests/ui/borrowck/fn-ptr-lifetime-mismatch-with-impl-trait-arg.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
