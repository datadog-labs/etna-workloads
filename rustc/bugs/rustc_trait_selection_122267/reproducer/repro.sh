#!/bin/bash
# Auto-generated from tests/ui/higher-ranked/builtin-closure-like-bounds.rs#current
cd "$(dirname "$0")"
"$RUSTC" --edition 2024 --cfg current --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
