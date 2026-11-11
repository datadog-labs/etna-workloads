#!/bin/bash
# Auto-generated from tests/ui/suggestions/dont-suggest-borrow-whole-call-issue-155088.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
