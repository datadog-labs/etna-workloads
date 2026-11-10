#!/bin/bash
# Auto-generated from tests/ui/argument-suggestions/suggest-better-removing-issue-126246.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
