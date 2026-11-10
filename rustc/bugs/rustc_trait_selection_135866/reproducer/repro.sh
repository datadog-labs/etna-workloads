#!/bin/bash
# Auto-generated from tests/ui/traits/next-solver/diagnostics/dont-pick-fnptr-bound-as-leaf.rs#next
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver --cfg next -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
