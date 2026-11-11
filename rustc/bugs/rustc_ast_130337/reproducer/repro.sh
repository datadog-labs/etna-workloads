#!/bin/bash
# Auto-generated from tests/ui/const-generics/early/trivial-const-arg-macro-nested-braces-2.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
