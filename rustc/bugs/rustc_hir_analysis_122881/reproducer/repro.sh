#!/bin/bash
# Auto-generated from tests/ui/delegation/ice-issue-122550.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
