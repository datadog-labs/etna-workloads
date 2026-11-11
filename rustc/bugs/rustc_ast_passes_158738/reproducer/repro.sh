#!/bin/bash
# Auto-generated from tests/ui/const-generics/generic_const_exprs/next-solver-gce-incompatible-issue-158428.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver=globally -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
