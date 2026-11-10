#!/bin/bash
# Auto-generated from tests/ui/parser/or-in-let-chain.rs#edition2021
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 --cfg edition2021 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
