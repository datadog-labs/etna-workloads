#!/bin/bash
# Auto-generated from tests/ui/suggestions/issue-105226.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
