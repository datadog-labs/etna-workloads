#!/bin/bash
# Auto-generated from tests/ui/pattern/usefulness/issue-85222-types-containing-non-exhaustive-types.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
