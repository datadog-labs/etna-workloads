#!/bin/bash
# Auto-generated from tests/mir-opt/jump_threading.rs
cd "$(dirname "$0")"
"$RUSTC" -Zmir-enable-passes=+Inline -Zmir-opt-level=1 --emit=mir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
