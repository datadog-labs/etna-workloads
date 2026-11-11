#!/bin/bash
# Auto-generated from tests/ui/const-generics/adt_const_params/unsizing-wfcheck-issue-126272.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
