#!/bin/bash
# Auto-generated from tests/ui/const-generics/mgca/type-const-free-anon-const-mismatch.rs
cd "$(dirname "$0")"
"$RUSTC" -Zvalidate-mir -Znext-solver -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
