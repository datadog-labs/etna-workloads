#!/bin/bash
# Auto-generated from tests/ui/traits/next-solver/diagnostics/iterator-item-suggest-no-ice.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
