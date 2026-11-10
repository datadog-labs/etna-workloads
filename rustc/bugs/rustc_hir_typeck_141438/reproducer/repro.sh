#!/bin/bash
# Auto-generated from tests/ui/self/dispatch-dyn-incompatible-that-does-not-deref.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
