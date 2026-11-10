#!/bin/bash
# Auto-generated from tests/ui/half-open-range-patterns/half-open-range-pats-inclusive-match-arrow.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
