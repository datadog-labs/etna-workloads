#!/bin/bash
# Auto-generated from tests/ui/mir/ssa-range-prop-bb-self-domination.rs
cd "$(dirname "$0")"
"$RUSTC" -Copt-level=2 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
