#!/bin/bash
# Auto-generated from tests/ui/lifetimes/trait-impl-mismatch-elided-lifetime-issue-65866.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
