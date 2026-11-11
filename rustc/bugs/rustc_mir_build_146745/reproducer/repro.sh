#!/bin/bash
# Auto-generated from tests/ui/feature-gates/feature-gate-precise_pointer_size_matching.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
