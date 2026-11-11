#!/bin/bash
# Auto-generated from tests/ui/type/type-check/point-at-inference-issue-116155.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
