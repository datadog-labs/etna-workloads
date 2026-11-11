#!/bin/bash
# Auto-generated from tests/ui/moves/invalid-suggestions-destructuring-assignment-drop.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
