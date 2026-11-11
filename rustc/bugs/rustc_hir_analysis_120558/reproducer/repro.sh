#!/bin/bash
# Auto-generated from tests/ui/traits/next-solver/coherence/trait_ref_is_knowable-norm-overflow.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
