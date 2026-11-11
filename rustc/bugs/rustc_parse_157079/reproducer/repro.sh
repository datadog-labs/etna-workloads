#!/bin/bash
# Auto-generated from tests/ui/parser/recover/raw-no-const-mut-arg-list.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
