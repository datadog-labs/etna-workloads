#!/bin/bash
# Auto-generated from tests/ui/compile-flags/invalid/codegen-option-typo-suggestion-issue-159482.rs#codegen
cd "$(dirname "$0")"
"$RUSTC" -Copt-leve=2 --cfg codegen -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
