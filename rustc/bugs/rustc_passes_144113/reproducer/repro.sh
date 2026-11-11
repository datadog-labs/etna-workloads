#!/bin/bash
# Auto-generated from tests/ui/lint/dead-code/allow-trait-or-impl.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
