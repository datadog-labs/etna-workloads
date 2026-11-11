#!/bin/bash
# Auto-generated from tests/ui/borrowck/move-error-suggest-clone-panic-issue-127915.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
