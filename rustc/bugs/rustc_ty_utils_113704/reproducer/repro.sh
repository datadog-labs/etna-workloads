#!/bin/bash
# Auto-generated from tests/ui/impl-trait/in-trait/assumed-wf-bounds-in-impl.rs
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
