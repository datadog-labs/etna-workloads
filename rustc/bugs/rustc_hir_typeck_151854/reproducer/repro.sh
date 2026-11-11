#!/bin/bash
# Auto-generated from tests/ui/let-else/let-else-break-help-issue-142602.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
