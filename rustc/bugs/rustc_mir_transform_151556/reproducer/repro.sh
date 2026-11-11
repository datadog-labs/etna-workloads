#!/bin/bash
# Auto-generated from tests/ui/lint/issue-49588-non-shorthand-field-patterns-in-pattern-macro.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
[ -x prog ] && { ./prog 2>&1; echo "program exit: $?"; }
rm -f prog out.rmeta
