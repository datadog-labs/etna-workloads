#!/bin/bash
# Auto-generated from tests/ui/drop/recursion-check-on-erroneous-impl.rs
cd "$(dirname "$0")"
"$RUSTC" --emit=mir -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
