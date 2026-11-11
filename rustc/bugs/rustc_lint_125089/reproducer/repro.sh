#!/bin/bash
# Auto-generated from tests/ui/lint/non-local-defs/exhaustive.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
