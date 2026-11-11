#!/bin/bash
# Auto-generated from tests/ui/lint/unused/unused-field-in-pat-field.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
