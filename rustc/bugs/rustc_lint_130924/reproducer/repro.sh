#!/bin/bash
# Auto-generated from tests/ui/lint/clashing-extern-fn-issue-130851.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
