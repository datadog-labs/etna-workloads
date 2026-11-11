#!/bin/bash
# Auto-generated from tests/ui/traits/non_lifetime_binders/normalized-param-env-unconstrained-type-120033.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
