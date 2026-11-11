#!/bin/bash
# Auto-generated from tests/ui/borrowck/issue-119915-bad-clone-suggestion.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
