#!/bin/bash
# Auto-generated from tests/ui/lint/lints-on-stmt-not-overridden-130142.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
