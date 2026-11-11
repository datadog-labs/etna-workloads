#!/bin/bash
# Auto-generated from tests/ui/macros/failed-to-reparse-issue-137874.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
