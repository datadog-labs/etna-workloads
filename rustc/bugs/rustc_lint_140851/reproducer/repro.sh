#!/bin/bash
# Auto-generated from tests/ui/generics/export-name-on-generics.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
