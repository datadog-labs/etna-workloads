#!/bin/bash
# Auto-generated from tests/ui/nll/member-constraints/non-root-universe-existential-1.rs#current
cd "$(dirname "$0")"
"$RUSTC" --cfg current --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
