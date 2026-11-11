#!/bin/bash
# Auto-generated from tests/ui/const-generics/invalid-rustc_legacy_const_generics-issue-123077.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
