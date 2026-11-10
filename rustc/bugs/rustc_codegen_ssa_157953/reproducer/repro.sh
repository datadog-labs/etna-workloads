#!/bin/bash
# Auto-generated from tests/ui/generics/ssa-rval-monomorphization-issue-157922.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
