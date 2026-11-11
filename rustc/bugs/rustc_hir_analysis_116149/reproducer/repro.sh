#!/bin/bash
# Auto-generated from tests/ui/impl-trait/in-trait/anonymize-binders-for-refine.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
