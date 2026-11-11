#!/bin/bash
# Auto-generated from tests/ui/argument-suggestions/disjoint-spans-issue-151607.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
