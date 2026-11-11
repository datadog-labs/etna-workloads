#!/bin/bash
# Auto-generated from tests/ui/binop/binary-op-not-allowed-issue-125631.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
