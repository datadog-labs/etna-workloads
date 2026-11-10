#!/bin/bash
# Auto-generated from tests/ui/mir/inline-causes-trimmed-paths.rs
cd "$(dirname "$0")"
"$RUSTC" -Zinline-mir -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
