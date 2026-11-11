#!/bin/bash
# Auto-generated from tests/ui/lint/lint-unconditional-drop-recursion.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
