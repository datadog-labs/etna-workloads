#!/bin/bash
# Auto-generated from tests/ui/borrowck/alias-liveness/rpitit-hide-lifetime-for-swap.rs#polonius_alpha
cd "$(dirname "$0")"
"$RUSTC" -Zpolonius=next --edition 2024 --cfg polonius_alpha -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
