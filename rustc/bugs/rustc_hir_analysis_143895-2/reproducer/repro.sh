#!/bin/bash
# Auto-generated from tests/ui/traits/const-traits/const-assoc-bound-in-trait-wc.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
