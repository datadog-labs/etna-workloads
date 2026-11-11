#!/bin/bash
# Auto-generated from tests/ui/binop/let-chain-type-issue-147665.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2024 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
