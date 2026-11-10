#!/bin/bash
# Auto-generated from tests/ui/associated-types/associated-type-as-value-in-impl-issue-142797.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
