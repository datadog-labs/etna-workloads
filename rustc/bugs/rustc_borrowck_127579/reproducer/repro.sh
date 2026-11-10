#!/bin/bash
# Auto-generated from tests/ui/borrowck/mut-borrow-in-loop-2.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
