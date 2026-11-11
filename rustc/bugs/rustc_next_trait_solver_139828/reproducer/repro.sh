#!/bin/bash
# Auto-generated from tests/ui/coroutine/higher-ranked-rigid.rs#next
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver --edition 2024 --cfg next --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
