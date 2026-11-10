#!/bin/bash
# Auto-generated from tests/mir-opt/elaborate_box_deref_in_debuginfo.rs
cd "$(dirname "$0")"
"$RUSTC"  -Zmir-opt-level=1 --emit=mir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
