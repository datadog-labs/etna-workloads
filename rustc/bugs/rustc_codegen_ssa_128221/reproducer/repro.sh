#!/bin/bash
# Auto-generated from tests/ui/target-feature/asm-implied-features-issue-128125.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
