#!/bin/bash
# Auto-generated from tests/ui/traits/next-solver/cycles/coinduction/incompleteness-unstable-result.rs#with
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver --cfg with -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
