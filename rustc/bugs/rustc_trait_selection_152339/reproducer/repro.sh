#!/bin/bash
# Auto-generated from tests/ui/closures/closure-arg-borrow-ice-issue-152331.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
