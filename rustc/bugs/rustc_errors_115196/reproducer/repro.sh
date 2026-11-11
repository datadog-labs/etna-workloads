#!/bin/bash
# Auto-generated from tests/ui/inference/issue-86094-suggest-add-return-to-coerce-ret-ty.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
