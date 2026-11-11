#!/bin/bash
# Auto-generated from tests/ui/borrowck/argument_number_mismatch_ice.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
