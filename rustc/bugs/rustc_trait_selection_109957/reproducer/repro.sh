#!/bin/bash
# Auto-generated from tests/ui/inference/need_type_info/issue-109905.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
