#!/bin/bash
# Auto-generated from tests/ui/type-alias-impl-trait/rpit_tait_equality_in_canonical_query.rs#current
cd "$(dirname "$0")"
"$RUSTC" --cfg current --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
