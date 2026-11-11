#!/bin/bash
# Auto-generated from tests/ui/lint/unused/unused-async.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2018 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
