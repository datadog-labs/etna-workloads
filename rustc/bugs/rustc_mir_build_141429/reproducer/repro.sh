#!/bin/bash
# Auto-generated from tests/ui/unsafe-binders/non-strucutral-type-diag.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
