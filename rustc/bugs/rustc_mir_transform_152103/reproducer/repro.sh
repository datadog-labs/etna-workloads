#!/bin/bash
# Auto-generated from tests/ui/lint/unused/diverging-path.rs
cd "$(dirname "$0")"
"$RUSTC" -Wunused --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
