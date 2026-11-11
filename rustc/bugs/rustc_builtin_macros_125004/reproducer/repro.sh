#!/bin/bash
# Auto-generated from tests/ui/macros/println-percent-prefix-num-issue-125002.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
