#!/bin/bash
# Auto-generated from tests/ui/parser/doc-comment-after-missing-comma-issue-142311.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
