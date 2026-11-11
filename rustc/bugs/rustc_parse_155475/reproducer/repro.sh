#!/bin/bash
# Auto-generated from tests/ui/macros/macro-guard-matcher-recursion.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
