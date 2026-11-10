#!/bin/bash
# Auto-generated from tests/ui/lifetimes/lifetime-errors/liveness-assign-imm-local-notes.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
