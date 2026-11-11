#!/bin/bash
# Auto-generated from tests/ui/macros/deref-raw-pointer-issue-158158.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
