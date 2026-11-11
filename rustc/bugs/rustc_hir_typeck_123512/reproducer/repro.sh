#!/bin/bash
# Auto-generated from tests/ui/pattern/rfc-3627-match-ergonomics-2024/experimental/borrowck-errors.rs#structural2024
cd "$(dirname "$0")"
"$RUSTC" --edition 2024 --cfg structural2024 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
