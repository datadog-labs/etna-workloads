#!/bin/bash
# Auto-generated from tests/ui/impl-trait/non-defining-uses/ice-issue-146191.rs#current
cd "$(dirname "$0")"
"$RUSTC" --edition 2024 --cfg current -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
