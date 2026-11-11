#!/bin/bash
# Auto-generated from tests/ui/lint/dead-code/issue-41883.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
