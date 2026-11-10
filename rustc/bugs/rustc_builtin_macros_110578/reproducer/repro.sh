#!/bin/bash
# Auto-generated from tests/ui/env-macro/name-whitespace-issue-110547.rs
cd "$(dirname "$0")"
"$RUSTC" -C debug-assertions -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
