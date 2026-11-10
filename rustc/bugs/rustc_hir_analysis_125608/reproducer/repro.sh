#!/bin/bash
# Auto-generated from tests/ui/traits/generic_param_mismatch_in_unsatisfied_projection.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
