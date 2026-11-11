#!/bin/bash
# Auto-generated from tests/ui/impl-trait/precise-capturing/redundant.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2024 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
