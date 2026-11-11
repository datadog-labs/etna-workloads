#!/bin/bash
# Auto-generated from tests/ui/traits/const-traits/const-closure-inherited-const-condition.rs#old
cd "$(dirname "$0")"
"$RUSTC" --cfg old --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
