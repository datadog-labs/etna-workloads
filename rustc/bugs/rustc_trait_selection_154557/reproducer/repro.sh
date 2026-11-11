#!/bin/bash
# Auto-generated from tests/ui/inference/need_type_info/single-const-generic-suggestion.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
