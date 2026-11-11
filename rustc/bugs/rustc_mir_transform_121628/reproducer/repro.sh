#!/bin/bash
# Auto-generated from tests/ui/lint/ice-unions-known-panics-lint-issue-121534.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
