#!/bin/bash
# Auto-generated from tests/ui/block-result/block-must-not-have-result-while.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
