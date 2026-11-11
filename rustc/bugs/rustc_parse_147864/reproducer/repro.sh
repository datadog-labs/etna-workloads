#!/bin/bash
# Auto-generated from tests/ui/traits/const-traits/parse-const-unsafe-trait.rs
cd "$(dirname "$0")"
"$RUSTC" -Zparse-crate-root-only --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
