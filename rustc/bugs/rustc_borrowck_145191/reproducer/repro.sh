#!/bin/bash
# Auto-generated from tests/ui/moves/use-correct-generic-args-in-borrow-suggest.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
