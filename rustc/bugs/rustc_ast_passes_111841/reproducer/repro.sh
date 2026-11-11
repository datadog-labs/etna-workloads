#!/bin/bash
# Auto-generated from tests/ui/rfcs/rfc-2497-if-let-chains/ast-validate-guards.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2024 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
