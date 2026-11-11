#!/bin/bash
# Auto-generated from tests/ui/intrinsics/incorrect-read_via_copy-defn.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
