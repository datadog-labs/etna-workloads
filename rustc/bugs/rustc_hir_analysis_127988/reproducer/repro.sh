#!/bin/bash
# Auto-generated from tests/ui/duplicate/multiple-types-with-same-name-and-derive.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
