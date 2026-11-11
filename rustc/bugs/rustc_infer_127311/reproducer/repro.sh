#!/bin/bash
# Auto-generated from tests/ui/const-generics/issues/issue-71381.rs#full
cd "$(dirname "$0")"
"$RUSTC" --cfg full -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
