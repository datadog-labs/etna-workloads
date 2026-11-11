#!/bin/bash
# Auto-generated from tests/ui/consts/value-suggestion-ice-123906.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
