#!/bin/bash
# Auto-generated from tests/ui/loop-match/diverges.rs
cd "$(dirname "$0")"
"$RUSTC" -Zvalidate-mir -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
