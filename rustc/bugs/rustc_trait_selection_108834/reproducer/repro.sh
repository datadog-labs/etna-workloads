#!/bin/bash
# Auto-generated from tests/ui/higher-ranked/trait-bounds/fn-ptr.rs#current
cd "$(dirname "$0")"
"$RUSTC" --cfg current --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
