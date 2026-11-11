#!/bin/bash
# Auto-generated from tests/ui/generics/wrong-number-of-args-in-macro.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
