#!/bin/bash
# Auto-generated from tests/ui/codegen/empty-static-libs-issue-108825.rs
cd "$(dirname "$0")"
"$RUSTC" -Cpanic=abort --print=native-static-libs -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
