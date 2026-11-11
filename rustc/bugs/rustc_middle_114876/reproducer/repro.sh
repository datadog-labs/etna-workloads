#!/bin/bash
# Auto-generated from tests/ui/traits/non_lifetime_binders/sized-late-bound-issue-114872.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
