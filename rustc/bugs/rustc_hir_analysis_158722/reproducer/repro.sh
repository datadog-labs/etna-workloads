#!/bin/bash
# Auto-generated from tests/ui/delegation/generics/const-predicates-ice-158675.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
