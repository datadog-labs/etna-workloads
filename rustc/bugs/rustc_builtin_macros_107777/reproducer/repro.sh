#!/bin/bash
# Auto-generated from tests/ui/traits/const-traits/const_derives/derive-const-with-params.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
