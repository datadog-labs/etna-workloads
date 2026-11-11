#!/bin/bash
# Auto-generated from tests/ui/for-loop-while/dont-suggest-break-from-unbreakable-loops.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
