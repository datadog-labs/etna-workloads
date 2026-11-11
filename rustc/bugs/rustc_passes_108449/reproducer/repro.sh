#!/bin/bash
# Auto-generated from tests/ui/stability-attribute/unresolved_stability_lint.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
