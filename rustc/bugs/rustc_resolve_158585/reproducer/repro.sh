#!/bin/bash
# Auto-generated from tests/ui/resolve/too-many-super-issue-158275.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
