#!/bin/bash
# Auto-generated from tests/ui/const-generics/mgca/printing_valtrees_supports_non_values.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2024 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
