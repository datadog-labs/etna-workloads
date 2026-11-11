#!/bin/bash
# Auto-generated from tests/ui/symbol-names/const-in-global-asm.rs
cd "$(dirname "$0")"
"$RUSTC" -Clink-dead-code -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
