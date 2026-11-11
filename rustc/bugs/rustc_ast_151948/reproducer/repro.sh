#!/bin/bash
# Auto-generated from tests/ui/macros/tokenstream-ice-issue-149954.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2024 --crate-type=lib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
