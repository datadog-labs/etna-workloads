#!/bin/bash
# Auto-generated from tests/ui/const-generics/mgca/type-const-inherent-value-type-mismatch.rs#next
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver -Zvalidate-mir --cfg next -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
