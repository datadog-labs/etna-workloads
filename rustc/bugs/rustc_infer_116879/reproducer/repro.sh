#!/bin/bash
# Auto-generated from tests/ui/impl-trait/equality-in-canonical-query.rs#clone
cd "$(dirname "$0")"
"$RUSTC" --cfg clone --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
