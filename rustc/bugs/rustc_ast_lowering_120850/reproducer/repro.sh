#!/bin/bash
# Auto-generated from tests/ui/imports/empty-import-prefix-pass-2015.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2015 --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
