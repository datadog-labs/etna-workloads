#!/bin/bash
# Auto-generated from tests/ui/attributes/invalid_macro_export_argument.rs#allow
cd "$(dirname "$0")"
"$RUSTC" --cfg allow --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
