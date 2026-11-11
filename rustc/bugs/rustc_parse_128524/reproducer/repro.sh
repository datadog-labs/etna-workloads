#!/bin/bash
# Auto-generated from tests/ui/parser/issues/isgg-invalid-outer-attttr-issue-127930.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
