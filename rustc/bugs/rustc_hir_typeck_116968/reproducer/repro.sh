#!/bin/bash
# Auto-generated from tests/ui/type/type-check/issue-116967-cannot-coerce-returned-result.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
