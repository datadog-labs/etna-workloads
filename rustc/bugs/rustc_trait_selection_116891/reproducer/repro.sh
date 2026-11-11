#!/bin/bash
# Auto-generated from tests/ui/impl-trait/defining-use-captured-non-universal-region.rs#infer
cd "$(dirname "$0")"
"$RUSTC" --cfg infer -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
