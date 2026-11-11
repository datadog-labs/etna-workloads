#!/bin/bash
# Auto-generated from tests/ui/span/let-offset-of.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2024 --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
