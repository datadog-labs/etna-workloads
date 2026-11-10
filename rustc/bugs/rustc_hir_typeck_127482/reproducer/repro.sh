#!/bin/bash
# Auto-generated from tests/ui/async-await/async-closures/signature-inference-from-two-part-bound.rs#current
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 --cfg current --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
