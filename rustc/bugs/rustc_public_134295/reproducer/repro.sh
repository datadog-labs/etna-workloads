#!/bin/bash
# Auto-generated from tests/ui/rustc_public-ir-print/async-closure.rs
cd "$(dirname "$0")"
"$RUSTC" -Z unpretty=stable-mir --crate-type lib -C panic=abort -Zmir-opt-level=0 --edition 2024 --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
