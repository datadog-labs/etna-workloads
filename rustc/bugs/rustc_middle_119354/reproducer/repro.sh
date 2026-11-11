#!/bin/bash
# Auto-generated from tests/ui/traits/negative-bounds/opaque-type-unsatisfied-bound.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver -Zinternal-testing-features -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
