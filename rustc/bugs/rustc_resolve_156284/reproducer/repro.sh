#!/bin/bash
# Auto-generated from tests/ui/imports/ambiguous-import-visibility-globglob-reexport.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
