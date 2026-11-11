#!/bin/bash
# Auto-generated from tests/ui/traits/const-traits/ice-149083-async-in-const-impl.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2024 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
