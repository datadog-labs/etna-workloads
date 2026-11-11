#!/bin/bash
# Auto-generated from tests/ui/traits/negative-bounds/supertrait.rs
cd "$(dirname "$0")"
"$RUSTC" -Zinternal-testing-features --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
