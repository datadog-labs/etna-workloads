#!/bin/bash
# Auto-generated from tests/ui/macros/macro-expansion-empty-span-147255.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
