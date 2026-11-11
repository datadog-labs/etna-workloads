#!/bin/bash
# Auto-generated from tests/ui/traits/next-solver/opaques/dump-layout-opaque-coroutine.rs#next
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver --edition 2024 --cfg next -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
