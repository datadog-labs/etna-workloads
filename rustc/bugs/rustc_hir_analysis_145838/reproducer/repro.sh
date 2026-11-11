#!/bin/bash
# Auto-generated from tests/ui/borrowck/format-args-temporary-scopes.rs#e2024
cd "$(dirname "$0")"
"$RUSTC" --edition 2024 --cfg e2024 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
