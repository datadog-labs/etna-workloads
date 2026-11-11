#!/bin/bash
# Auto-generated from tests/ui/type-alias-impl-trait/coherence/coherence_different_hidden_ty.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
