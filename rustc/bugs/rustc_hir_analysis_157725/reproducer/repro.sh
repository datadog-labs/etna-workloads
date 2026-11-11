#!/bin/bash
# Auto-generated from tests/ui/consts/const-item-no-type/in-macro.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
