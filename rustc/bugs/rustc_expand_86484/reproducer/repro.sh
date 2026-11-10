#!/bin/bash
# Auto-generated from tests/ui/macros/issue-84632-eager-expansion-recursion-limit.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
