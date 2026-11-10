#!/bin/bash
# Auto-generated from tests/ui/splat/arg-count-ice-issue-158482.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
