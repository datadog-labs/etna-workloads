#!/bin/bash
# Auto-generated from tests/ui/delegation/wrong-lifetime-rib.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2024 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
