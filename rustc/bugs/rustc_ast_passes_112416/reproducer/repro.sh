#!/bin/bash
# Auto-generated from tests/ui/extern/issue-112363-extern-item-where-clauses-debug-ice.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
