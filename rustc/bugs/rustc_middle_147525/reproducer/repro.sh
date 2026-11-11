#!/bin/bash
# Auto-generated from tests/ui/debuginfo/ref_prop_debuginfo-147485.rs
cd "$(dirname "$0")"
"$RUSTC" -g -O -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
