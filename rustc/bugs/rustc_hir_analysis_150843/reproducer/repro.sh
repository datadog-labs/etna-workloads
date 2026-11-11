#!/bin/bash
# Auto-generated from tests/ui/const-generics/associated-const-bindings/dyn-compat-const-projection-behind-trait-alias-mentions-self.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
