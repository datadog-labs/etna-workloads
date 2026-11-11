#!/bin/bash
# Auto-generated from tests/ui/async-await/async-closures/cast-as-infer-self-borrows.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
