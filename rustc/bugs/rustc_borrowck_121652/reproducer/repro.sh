#!/bin/bash
# Auto-generated from tests/ui/moves/recreating-value-in-loop-condition.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
