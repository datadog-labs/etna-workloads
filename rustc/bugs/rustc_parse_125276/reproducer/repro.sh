#!/bin/bash
# Auto-generated from tests/ui/parser/issues/fn-no-semicolon-issue-124935-semi-after-item.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
