#!/bin/bash
# Auto-generated from tests/ui/extern/extern-empty-string-issue-140884.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
