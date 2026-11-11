#!/bin/bash
# Auto-generated from tests/ui/inference/issue-70082.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
