#!/bin/bash
# Auto-generated from tests/ui/coercion/no_local_for_coerced_const-issue-143671.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
[ -x prog ] && { ./prog 2>&1; echo "program exit: $?"; }
rm -f prog out.rmeta
