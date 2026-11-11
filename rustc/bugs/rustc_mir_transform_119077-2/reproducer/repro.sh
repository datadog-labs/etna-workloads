#!/bin/bash
# Auto-generated from tests/ui/mir/lint/storage-return.rs
cd "$(dirname "$0")"
"$RUSTC" -Zlint-mir -Ztreat-err-as-bug -Zeagerly-emit-delayed-bugs -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
