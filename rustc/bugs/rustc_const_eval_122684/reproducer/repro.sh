#!/bin/bash
# Auto-generated from tests/ui/consts/miri_unleashed/mutable_references.rs
cd "$(dirname "$0")"
"$RUSTC" -Zunleash-the-miri-inside-of-you -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
