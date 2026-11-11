#!/bin/bash
# Auto-generated from tests/ui/delegation/generics/synth-params-ice-143498.rs
cd "$(dirname "$0")"
"$RUSTC" -Z deduplicate-diagnostics=yes --edition 2024 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
