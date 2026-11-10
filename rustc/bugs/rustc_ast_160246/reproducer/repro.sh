#!/bin/bash
# Auto-generated from tests/ui/pin-ergonomics/unused-mut.rs
cd "$(dirname "$0")"
"$RUSTC" --force-warn unused-mut --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
