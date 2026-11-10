#!/bin/bash
# Auto-generated from tests/ui/traits/negative-bounds/on-unimplemented.rs
cd "$(dirname "$0")"
"$RUSTC" -Zinternal-testing-features -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
