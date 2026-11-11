#!/bin/bash
# Auto-generated from tests/ui/recursion/recursion_limit/invalid-attribute-105700.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
