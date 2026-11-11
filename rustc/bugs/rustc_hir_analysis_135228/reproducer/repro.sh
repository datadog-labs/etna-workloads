#!/bin/bash
# Auto-generated from tests/ui/self/phantomdata-in-coerce-and-dispatch-impls.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
