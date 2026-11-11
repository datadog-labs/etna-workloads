#!/bin/bash
# Auto-generated from tests/ui/generics/generic-higher-ranked-lifetime-issue-122714.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
