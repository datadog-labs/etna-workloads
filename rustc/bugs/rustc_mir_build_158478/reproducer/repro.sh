#!/bin/bash
# Auto-generated from tests/ui/traits/next-solver/opaques/wrong-typing-mode-ice-1.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver --edition 2024 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
