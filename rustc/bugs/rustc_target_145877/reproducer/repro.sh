#!/bin/bash
# Auto-generated from tests/ui/codegen/indirect-nocapture.rs
cd "$(dirname "$0")"
"$RUSTC" -Copt-level=2 -o prog main.rs 2>&1; echo "rustc exit: $?"
[ -x prog ] && { ./prog 2>&1; echo "program exit: $?"; }
rm -f prog out.rmeta
