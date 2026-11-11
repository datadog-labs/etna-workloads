#!/bin/bash
# Auto-generated from tests/mir-opt/copy-prop/borrowed_local.rs
cd "$(dirname "$0")"
"$RUSTC"  -Zmir-opt-level=1 --emit=mir -o - main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
