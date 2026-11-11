#!/bin/bash
# Auto-generated from tests/ui/const-generics/mgca/type-const-used-in-trait.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
