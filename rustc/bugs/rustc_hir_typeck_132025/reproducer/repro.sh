#!/bin/bash
# Auto-generated from tests/ui/destructuring-assignment/struct_destructure_fail.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
