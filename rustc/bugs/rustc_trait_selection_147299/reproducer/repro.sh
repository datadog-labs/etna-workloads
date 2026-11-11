#!/bin/bash
# Auto-generated from tests/ui/async-await/higher-ranked-normalize-assumptions-2.rs#stock
cd "$(dirname "$0")"
"$RUSTC" --edition 2024 --cfg stock --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
