#!/bin/bash
# Auto-generated from tests/ui/typeck/issue-90027-async-fn-return-suggestion.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2018 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
