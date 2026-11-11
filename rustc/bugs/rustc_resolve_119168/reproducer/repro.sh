#!/bin/bash
# Auto-generated from tests/ui/privacy/import-list-stem-visibility-issue-119126.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2018 --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
