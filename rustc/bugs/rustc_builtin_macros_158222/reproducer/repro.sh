#!/bin/bash
# Auto-generated from tests/ui/macros/trailing-percent-format-hint-issue-158216.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
