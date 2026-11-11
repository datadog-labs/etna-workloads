#!/bin/bash
# Auto-generated from tests/ui/consts/slice-index-overflow-issue-130284.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
