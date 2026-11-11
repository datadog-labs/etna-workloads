#!/bin/bash
# Auto-generated from tests/ui/traits/const-traits/constructor-const-fn.rs
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
