#!/bin/bash
# Auto-generated from tests/ui/unboxed-closures/paren-sugar-non-fn-trait-issue-153855.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
