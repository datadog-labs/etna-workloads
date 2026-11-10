#!/bin/bash
# Auto-generated from tests/ui/range/range-to-iterator-suggestion-issue-147749.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
