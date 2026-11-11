#!/bin/bash
# Auto-generated from tests/ui/mismatched_types/expectation-from-return-type.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
