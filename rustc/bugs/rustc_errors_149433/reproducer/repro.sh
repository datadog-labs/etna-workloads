#!/bin/bash
# Auto-generated from tests/ui/enum-discriminant/invalid-niche-discriminant.rs#normal
cd "$(dirname "$0")"
"$RUSTC" --cfg normal -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
