#!/bin/bash
# Auto-generated from tests/mir-opt/read_from_trivial_switch.rs
cd "$(dirname "$0")"
"$RUSTC" -Zmir-preserve-ub -Zmir-opt-level=1 --emit=mir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
