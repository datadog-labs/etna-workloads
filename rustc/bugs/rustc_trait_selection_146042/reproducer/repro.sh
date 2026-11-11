#!/bin/bash
# Auto-generated from tests/ui/suggestions/negative-literal-infered-to-unsigned.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
