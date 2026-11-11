#!/bin/bash
# Auto-generated from tests/ui/lint/unused/lint-unsed-in-macro-issue-151269.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
