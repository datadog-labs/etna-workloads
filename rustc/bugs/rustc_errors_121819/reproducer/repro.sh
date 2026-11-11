#!/bin/bash
# Auto-generated from tests/ui/typeck/invalid-stashed-level-issue-121812.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
