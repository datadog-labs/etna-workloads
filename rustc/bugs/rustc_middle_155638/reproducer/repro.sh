#!/bin/bash
# Auto-generated from tests/ui/async-await/async-fn/closure-arg-type-mismatch.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
