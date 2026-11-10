#!/bin/bash
# Auto-generated from tests/ui/coherence/negative-coherence-considering-regions.rs#any_lt
cd "$(dirname "$0")"
"$RUSTC" --cfg any_lt -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
