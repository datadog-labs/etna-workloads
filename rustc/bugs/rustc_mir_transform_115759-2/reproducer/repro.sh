#!/bin/bash
# Auto-generated from tests/ui/type-alias-impl-trait/destructure_tait-ice-113594.rs#current
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 --cfg current -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
