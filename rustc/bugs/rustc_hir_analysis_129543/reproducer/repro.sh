#!/bin/bash
# Auto-generated from tests/ui/object-lifetime/object-lifetime-default-gat-binding-item-bounds.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
