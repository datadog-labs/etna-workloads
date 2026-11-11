#!/bin/bash
# Auto-generated from tests/ui/traits/alias/issue-107747-do-not-assemble-supertraits.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
