#!/bin/bash
# Auto-generated from tests/ui/extern/extern-only-quotes-issue-147365.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
