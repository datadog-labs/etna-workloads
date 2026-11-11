#!/bin/bash
# Auto-generated from tests/ui/parser/issues/error-pattern-issue-50571.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2015 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
