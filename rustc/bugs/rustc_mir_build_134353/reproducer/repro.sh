#!/bin/bash
# Auto-generated from tests/ui/rfcs/rfc-2396-target_feature-11/fn-ptr.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
