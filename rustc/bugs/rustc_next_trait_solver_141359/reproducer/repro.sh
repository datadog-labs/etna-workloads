#!/bin/bash
# Auto-generated from tests/ui/async-await/async-closures/async-fn-mut-impl-fn-once.rs#next
cd "$(dirname "$0")"
"$RUSTC" -Znext-solver --edition 2021 --cfg next --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
