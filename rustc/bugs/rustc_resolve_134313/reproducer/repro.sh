#!/bin/bash
# Auto-generated from tests/ui/impl-trait/in-bindings/dont-make-def-id.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
