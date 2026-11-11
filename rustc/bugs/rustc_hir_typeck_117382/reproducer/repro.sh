#!/bin/bash
# Auto-generated from tests/ui/typeck/issue-114529-illegal-break-with-value.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
