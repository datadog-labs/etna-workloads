#!/bin/bash
# Auto-generated from tests/ui/traits/next-solver/coherence/coherence-fulfill-overflow.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver=coherence -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
