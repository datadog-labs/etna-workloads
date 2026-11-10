#!/bin/bash
# Auto-generated from tests/ui/self/arbitrary-self-from-method-substs.rs#default
cd "$(dirname "$0")"
"$RUSTC" --cfg default -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
