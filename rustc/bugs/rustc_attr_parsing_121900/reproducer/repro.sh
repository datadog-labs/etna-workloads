#!/bin/bash
# Auto-generated from tests/ui/attributes/arg-error-issue-121425.rs
cd "$(dirname "$0")"
"$RUSTC" -Zdeduplicate-diagnostics=yes -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
