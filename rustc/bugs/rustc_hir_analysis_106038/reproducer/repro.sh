#!/bin/bash
# Auto-generated from tests/ui/type-alias-impl-trait/wf-in-associated-type.rs#pass
cd "$(dirname "$0")"
"$RUSTC" --cfg pass --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
