#!/bin/bash
# Auto-generated from tests/ui/delegation/unlowered-path-ice-154820.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
