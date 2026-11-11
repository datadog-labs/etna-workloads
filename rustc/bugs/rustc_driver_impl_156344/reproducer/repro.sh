#!/bin/bash
# Auto-generated from tests/ui/explain/explanation-code-rendering-edge-case-regression.rs
cd "$(dirname "$0")"
"$RUSTC" --explain E0602 --color always --error-format=human --crate-type=lib --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
