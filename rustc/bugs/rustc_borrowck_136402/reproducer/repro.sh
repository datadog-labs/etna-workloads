#!/bin/bash
# Auto-generated from tests/ui/borrowck/already-borrowed-as-mutable-if-let-133941.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
