#!/bin/bash
# Auto-generated from tests/ui/type/clarify-error-for-generics-with-default-issue-120785.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
