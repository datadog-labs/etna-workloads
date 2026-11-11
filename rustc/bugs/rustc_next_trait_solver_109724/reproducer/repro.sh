#!/bin/bash
# Auto-generated from tests/ui/traits/next-solver/alias-relate/alias_eq_dont_use_normalizes_to_if_substs_eq.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
