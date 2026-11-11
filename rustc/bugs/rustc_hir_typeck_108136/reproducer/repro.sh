#!/bin/bash
# Auto-generated from tests/ui/traits/alias/issue-108132-unmet-trait-alias-bound-on-generic-impl.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
