#!/bin/bash
# Auto-generated from tests/ui/typeck/issue-112385-while-assign-lhs-place-expr-ice.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
