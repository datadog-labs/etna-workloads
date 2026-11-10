#!/bin/bash
# Auto-generated from tests/ui/compile-flags/invalid/invalid-crate-name-suggestion-issue-159485.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-name=my-crate -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
