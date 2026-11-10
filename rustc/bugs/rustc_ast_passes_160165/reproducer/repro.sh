#!/bin/bash
# Auto-generated from tests/ui/c-variadic/reject-varargs-without-pattern-post-expansion.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
