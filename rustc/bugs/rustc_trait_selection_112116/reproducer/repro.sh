#!/bin/bash
# Auto-generated from tests/ui/associated-types/dont-suggest-cyclic-constraint.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
