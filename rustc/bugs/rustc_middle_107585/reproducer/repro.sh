#!/bin/bash
# Auto-generated from tests/ui/query-system/no-query-in-printing-during-query-descr.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
