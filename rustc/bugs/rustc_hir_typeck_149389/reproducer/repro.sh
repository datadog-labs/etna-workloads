#!/bin/bash
# Auto-generated from tests/ui/regions/wf-bound-region-in-local-issue-115175.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
