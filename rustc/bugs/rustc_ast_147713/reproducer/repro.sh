#!/bin/bash
# Auto-generated from tests/ui/where-clauses/cfg-attr-issue-138010-1.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
