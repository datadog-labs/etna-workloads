#!/bin/bash
# Auto-generated from tests/ui/object-lifetime/object-lifetime-default-assoc-ty-self-ty.rs#bound
cd "$(dirname "$0")"
"$RUSTC" --cfg bound --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
