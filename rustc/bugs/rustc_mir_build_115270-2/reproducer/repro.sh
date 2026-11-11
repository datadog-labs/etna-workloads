#!/bin/bash
# Auto-generated from tests/ui/pattern/usefulness/issue-105479-str-non-exhaustiveness.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
