#!/bin/bash
# Auto-generated from tests/ui/impl-trait/defining-use-uncaptured-non-universal-region-2.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
