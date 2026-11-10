#!/bin/bash
# Auto-generated from tests/ui/specialization/min_specialization/specialize_with_generalize_lifetimes.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
