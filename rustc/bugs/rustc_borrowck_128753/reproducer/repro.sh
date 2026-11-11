#!/bin/bash
# Auto-generated from tests/ui/impl-trait/in-trait/cannot-capture-intersection.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
