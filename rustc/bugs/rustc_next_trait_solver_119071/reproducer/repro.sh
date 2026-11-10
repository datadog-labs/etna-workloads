#!/bin/bash
# Auto-generated from tests/ui/traits/next-solver/overflow/recursion-limit-normalizes-to-constraints.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver=coherence --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
