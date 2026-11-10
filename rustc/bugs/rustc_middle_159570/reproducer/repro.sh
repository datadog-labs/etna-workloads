#!/bin/bash
# Auto-generated from tests/ui/consts/extra-const-ub/pointee-type-with-error-issue-159560.rs
cd "$(dirname "$0")"
"$RUSTC" -Zextra-const-ub-checks -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
