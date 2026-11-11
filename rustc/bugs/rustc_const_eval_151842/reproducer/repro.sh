#!/bin/bash
# Auto-generated from tests/ui/coroutine/avoid-query-cycle-in-ctfe.rs
cd "$(dirname "$0")"
"$RUSTC" -O --edition 2018 --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
