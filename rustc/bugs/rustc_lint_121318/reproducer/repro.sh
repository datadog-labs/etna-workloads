#!/bin/bash
# Auto-generated from tests/ui/lint/unsafe_code/lint-global-asm-as-unsafe.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
