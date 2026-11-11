#!/bin/bash
# Auto-generated from tests/ui/parser/macro/kw-in-item-pos-recovery-151238.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
