#!/bin/bash
# Auto-generated from tests/ui/limits/vtable.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib --emit=mir -C debuginfo=0 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
