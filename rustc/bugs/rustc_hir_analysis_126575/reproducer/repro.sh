#!/bin/bash
# Auto-generated from tests/ui/type-alias/unresolved-assoc-ty-suggest-trait.rs#eager
cd "$(dirname "$0")"
"$RUSTC" --cfg eager -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
