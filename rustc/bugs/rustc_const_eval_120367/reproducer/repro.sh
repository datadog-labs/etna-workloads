#!/bin/bash
# Auto-generated from tests/ui/consts/let-irrefutable-pattern-ice-120337.rs
cd "$(dirname "$0")"
"$RUSTC"  --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
