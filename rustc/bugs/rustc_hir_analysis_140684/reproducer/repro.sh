#!/bin/bash
# Auto-generated from tests/ui/traits/object/constrain-via-unnecessary-bound.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
