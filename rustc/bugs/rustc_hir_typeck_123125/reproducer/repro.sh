#!/bin/bash
# Auto-generated from tests/ui/coercion/coerce-loop-issue-122561.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
