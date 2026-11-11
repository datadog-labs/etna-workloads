#!/bin/bash
# Auto-generated from tests/ui/expr/malformed_closure/missing_block_in_let_binding.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
