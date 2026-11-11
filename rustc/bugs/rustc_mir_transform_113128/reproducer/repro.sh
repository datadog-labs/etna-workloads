#!/bin/bash
# Auto-generated from tests/ui/lint/lint-unconditional-recursion-tail-calls.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
