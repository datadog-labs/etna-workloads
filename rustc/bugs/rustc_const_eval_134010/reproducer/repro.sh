#!/bin/bash
# Auto-generated from tests/ui/consts/promoted-type-error-issue-133968.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
