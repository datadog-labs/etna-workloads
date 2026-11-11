#!/bin/bash
# Auto-generated from tests/ui/lifetimes/missing-lifetime-in-assoc-type-1.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
