#!/bin/bash
# Auto-generated from tests/ui/impl-trait/unsize-cast-validation-rpit.rs
cd "$(dirname "$0")"
"$RUSTC" -Zvalidate-mir --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
