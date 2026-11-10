#!/bin/bash
# Auto-generated from tests/mir-opt/issue_72181_1.rs
cd "$(dirname "$0")"
"$RUSTC" -Z mir-opt-level=1 -Zmir-opt-level=1 --emit=mir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
