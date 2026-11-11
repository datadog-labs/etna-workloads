#!/bin/bash
# Auto-generated from tests/ui/nll/polonius/allow-backward-incompatible-drop-hint.rs
cd "$(dirname "$0")"
"$RUSTC" -Zpolonius --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
