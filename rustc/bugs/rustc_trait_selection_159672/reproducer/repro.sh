#!/bin/bash
# Auto-generated from tests/ui/suggestions/multiple_tuples_implement_same_trait_continuous_arities.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
