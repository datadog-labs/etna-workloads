#!/bin/bash
# Auto-generated from tests/ui/mir/dyn_metadata_sroa.rs
cd "$(dirname "$0")"
"$RUSTC" -Zmir-opt-level=5 -Zvalidate-mir -o prog main.rs 2>&1; echo "rustc exit: $?"
[ -x prog ] && { ./prog 2>&1; echo "program exit: $?"; }
rm -f prog out.rmeta
