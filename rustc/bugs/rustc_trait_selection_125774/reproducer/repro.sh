#!/bin/bash
# Auto-generated from tests/ui/specialization/default-proj-ty-as-type-of-const-issue-125757.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
