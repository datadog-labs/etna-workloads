#!/bin/bash
# Auto-generated from tests/ui/async-await/async-closures/by-move-body-inlined-attrs.rs
cd "$(dirname "$0")"
"$RUSTC" -Zinline-mir -Zvalidate-mir --edition 2024 --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
