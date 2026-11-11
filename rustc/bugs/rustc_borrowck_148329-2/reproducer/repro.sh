#!/bin/bash
# Auto-generated from tests/ui/regions/closure-prop-issue-104477-case1.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
