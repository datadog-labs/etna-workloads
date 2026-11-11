#!/bin/bash
# Auto-generated from tests/ui/async-await/higher-ranked-auto-trait-14.rs#no_assumptions
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 --cfg no_assumptions --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
