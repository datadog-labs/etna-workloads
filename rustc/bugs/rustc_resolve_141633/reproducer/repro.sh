#!/bin/bash
# Auto-generated from tests/ui/resolve/suggestions/sugg-field-in-format-string-issue-141136.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
