#!/bin/bash
# Auto-generated from tests/ui/async-await/async-closures/kind-due-to-arg-with-box-wrap.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2024 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
