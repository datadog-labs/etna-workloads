#!/bin/bash
# Auto-generated from tests/ui/trivial-bounds/everybody-copies.rs
cd "$(dirname "$0")"
"$RUSTC" -Zmir-enable-passes=+GVN -Zmir-enable-passes=+Inline -Zvalidate-mir --crate-type lib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
