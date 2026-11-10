#!/bin/bash
# Auto-generated from tests/ui/traits/vtable/missing-generics-issue-151330.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver=globally -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
