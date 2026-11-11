#!/bin/bash
# Auto-generated from tests/ui/mir/lint/no-storage.rs
cd "$(dirname "$0")"
"$RUSTC" -Zlint-mir --crate-type=lib -Ztreat-err-as-bug -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
