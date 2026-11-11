#!/bin/bash
# Auto-generated from tests/ui/traits/alias/issue-108072-unmet-trait-alias-bound.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
