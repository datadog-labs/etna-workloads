#!/bin/bash
# Auto-generated from tests/ui/delegation/generics/const-type-ice-153433.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
