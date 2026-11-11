#!/bin/bash
# Auto-generated from tests/ui/lifetimes/lifetime-errors/e0621-mut-ref-aliases-pointee-lifetime.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
