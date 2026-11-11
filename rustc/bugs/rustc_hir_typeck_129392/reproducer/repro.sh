#!/bin/bash
# Auto-generated from tests/mir-opt/uninhabited_not_read.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 -Zmir-opt-level=1 --emit=mir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
