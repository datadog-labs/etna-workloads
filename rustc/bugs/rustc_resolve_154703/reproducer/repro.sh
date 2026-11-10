#!/bin/bash
# Auto-generated from tests/ui/lifetimes/E0106-trailing-comma-in-lifetime-suggestion.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
