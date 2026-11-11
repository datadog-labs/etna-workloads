#!/bin/bash
# Auto-generated from tests/ui/lint/issue-117949.rs#noopt
cd "$(dirname "$0")"
"$RUSTC" -C opt-level=0 -Z deduplicate-diagnostics=yes --cfg noopt -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
