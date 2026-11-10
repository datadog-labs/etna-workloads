#!/bin/bash
# Auto-generated from tests/ui/traits/non_lifetime_binders/object-lifetime-default-for-late.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
