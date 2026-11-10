#!/bin/bash
# Auto-generated from tests/ui/traits/negative-impls/ambiguity-cause.rs#negative_coherence
cd "$(dirname "$0")"
"$RUSTC" --cfg negative_coherence -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
