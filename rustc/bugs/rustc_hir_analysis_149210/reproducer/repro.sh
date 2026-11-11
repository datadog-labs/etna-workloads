#!/bin/bash
# Auto-generated from tests/ui/static/extern-static-normalization-failure-issue-148161.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
