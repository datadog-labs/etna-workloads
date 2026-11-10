#!/bin/bash
# Auto-generated from tests/ui/did_you_mean/issue-48492-tuple-destructure-missing-parens.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
