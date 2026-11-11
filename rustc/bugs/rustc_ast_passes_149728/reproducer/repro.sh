#!/bin/bash
# Auto-generated from tests/ui/traits/non_lifetime_binders/bad-bounds.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2024 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
