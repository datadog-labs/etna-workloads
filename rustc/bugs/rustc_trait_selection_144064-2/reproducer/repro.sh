#!/bin/bash
# Auto-generated from tests/ui/consts/const-size_of_val-align_of_val-extern-type.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
