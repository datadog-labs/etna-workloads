#!/bin/bash
# Auto-generated from tests/ui/lint/let_underscore/issue-119696-err-on-fn.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
