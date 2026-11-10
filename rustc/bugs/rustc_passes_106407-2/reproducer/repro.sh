#!/bin/bash
# Auto-generated from tests/ui/proc-macro/proc-macro-abi.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
