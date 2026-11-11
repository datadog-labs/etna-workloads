#!/bin/bash
# Auto-generated from tests/ui/traits/non_lifetime_binders/foreach-partial-eq-next-solver.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver=globally -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
