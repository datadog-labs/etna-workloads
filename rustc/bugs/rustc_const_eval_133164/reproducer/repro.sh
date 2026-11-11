#!/bin/bash
# Auto-generated from tests/ui/consts/promoted_running_out_of_memory_issue-130687.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
