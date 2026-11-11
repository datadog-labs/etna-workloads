#!/bin/bash
# Auto-generated from tests/ui/generic-associated-types/multiple-type-params-with-unmet-bounds.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
