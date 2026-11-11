#!/bin/bash
# Auto-generated from tests/ui/const-generics/mgca/generic-args-on-enum-variant-segments-fail.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
