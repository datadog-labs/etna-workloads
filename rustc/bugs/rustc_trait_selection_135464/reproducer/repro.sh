#!/bin/bash
# Auto-generated from tests/ui/structs/ice-struct-tail-normalization-113272.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
