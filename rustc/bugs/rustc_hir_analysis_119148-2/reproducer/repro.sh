#!/bin/bash
# Auto-generated from tests/ui/traits/bound/not-on-bare-trait-2021.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
