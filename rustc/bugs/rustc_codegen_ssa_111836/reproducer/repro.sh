#!/bin/bash
# Auto-generated from tests/ui/rfcs/rfc-2396-target_feature-11/issue-108655-inline-always-closure.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
