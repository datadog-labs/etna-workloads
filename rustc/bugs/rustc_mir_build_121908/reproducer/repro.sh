#!/bin/bash
# Auto-generated from tests/ui/pattern/usefulness/integer-ranges/regression-switchint-sorting-with-ranges.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
[ -x prog ] && { ./prog 2>&1; echo "program exit: $?"; }
rm -f prog out.rmeta
