#!/bin/bash
# Auto-generated from tests/ui/lint/dead-code/unused-trait-with-assoc-const.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
