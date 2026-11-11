#!/bin/bash
# Auto-generated from tests/ui/let-else/uninitialized-refutable-let-issue-123844.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
