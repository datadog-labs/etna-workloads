#!/bin/bash
# Auto-generated from tests/ui/macros/nested-use-as.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2018 --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
