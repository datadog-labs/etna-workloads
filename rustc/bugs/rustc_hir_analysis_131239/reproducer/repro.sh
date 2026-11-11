#!/bin/bash
# Auto-generated from tests/ui/rust-2021/ice-return-unsized-can-impl-2.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
