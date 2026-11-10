#!/bin/bash
# Auto-generated from tests/ui/pattern/deref-patterns/dont-ice-on-slice-in-deref-pat-in-closure.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
