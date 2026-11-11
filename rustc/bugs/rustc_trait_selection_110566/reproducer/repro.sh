#!/bin/bash
# Auto-generated from tests/ui/const-generics/associated-const-bindings/projection-unspecified-but-bounded.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
