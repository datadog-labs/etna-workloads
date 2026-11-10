#!/bin/bash
# Auto-generated from tests/ui/lint/unused/unused_parens/unused-parens-in-macro-issue-120642.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
[ -x prog ] && { ./prog 2>&1; echo "program exit: $?"; }
rm -f prog out.rmeta
