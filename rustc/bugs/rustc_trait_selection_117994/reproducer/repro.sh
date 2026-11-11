#!/bin/bash
# Auto-generated from tests/ui/coherence/negative-coherence-placeholder-region-constraints-on-unification.rs#implicit
cd "$(dirname "$0")"
"$RUSTC" --cfg implicit --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
