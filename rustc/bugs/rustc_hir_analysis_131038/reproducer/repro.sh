#!/bin/bash
# Auto-generated from tests/ui/generic-const-items/wfcheck_err_leak_issue_118179.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
