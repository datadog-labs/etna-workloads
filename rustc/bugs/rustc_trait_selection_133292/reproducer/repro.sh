#!/bin/bash
# Auto-generated from tests/ui/suggestions/issue-84973-blacklist.rs
cd "$(dirname "$0")"
"$RUSTC" --diagnostic-width=300 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
