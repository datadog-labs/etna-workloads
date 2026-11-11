#!/bin/bash
# Auto-generated from tests/ui/traits/next-solver/rpitit-cycle-due-to-rigid.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver --edition 2024 --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
