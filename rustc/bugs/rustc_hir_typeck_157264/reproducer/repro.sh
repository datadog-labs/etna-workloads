#!/bin/bash
# Auto-generated from tests/ui/methods/method-suggestion-trait-with-extra-generics-no-ice.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
