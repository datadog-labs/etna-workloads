#!/bin/bash
# Auto-generated from tests/ui/typeck/suggestions/macro-shorthand-issue-140659.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
