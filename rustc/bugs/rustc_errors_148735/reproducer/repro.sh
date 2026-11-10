#!/bin/bash
# Auto-generated from tests/ui/structs/ice-line-bounds-issue-148684.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
