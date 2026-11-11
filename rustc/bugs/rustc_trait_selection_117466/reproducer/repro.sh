#!/bin/bash
# Auto-generated from tests/ui/borrowck/alias-liveness/escaping-bounds-2.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
