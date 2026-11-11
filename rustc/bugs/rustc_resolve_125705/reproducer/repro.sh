#!/bin/bash
# Auto-generated from tests/ui/inline-const/referencing-local-variables.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
