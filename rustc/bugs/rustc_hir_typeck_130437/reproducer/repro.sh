#!/bin/bash
# Auto-generated from tests/ui/mismatched_types/mismatch-args-vargs-issue-130372.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
