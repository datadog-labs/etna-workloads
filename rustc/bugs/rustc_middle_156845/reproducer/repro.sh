#!/bin/bash
# Auto-generated from tests/ui/closures/generic-typed-nested-closures-59494.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
