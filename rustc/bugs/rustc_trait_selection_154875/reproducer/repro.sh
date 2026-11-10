#!/bin/bash
# Auto-generated from tests/ui/regions/impl-trait-lifetime-conflict-hashmap-keys.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
