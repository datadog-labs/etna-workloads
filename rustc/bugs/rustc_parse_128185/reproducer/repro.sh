#!/bin/bash
# Auto-generated from tests/ui/suggestions/suggest-add-self-issue-128042.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
