#!/bin/bash
# Auto-generated from tests/ui/label/continue-pointing-to-block-ice-113379.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2015 --crate-type=lib -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
