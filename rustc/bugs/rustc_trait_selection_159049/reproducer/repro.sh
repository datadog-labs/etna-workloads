#!/bin/bash
# Auto-generated from tests/ui/traits/explicit-reference-cast-hrtb.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
