#!/bin/bash
# Auto-generated from tests/mir-opt/building/loop_match_no_self_assign.rs
cd "$(dirname "$0")"
"$RUSTC"  -Zmir-opt-level=1 --emit=mir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
