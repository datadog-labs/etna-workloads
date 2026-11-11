#!/bin/bash
# Auto-generated from tests/ui/contracts/requires-block-stmt.rs
cd "$(dirname "$0")"
"$RUSTC" -Zcontract-checks=yes -o prog main.rs 2>&1; echo "rustc exit: $?"
[ -x prog ] && { ./prog 2>&1; echo "program exit: $?"; }
rm -f prog out.rmeta
