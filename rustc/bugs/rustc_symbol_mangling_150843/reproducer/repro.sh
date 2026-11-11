#!/bin/bash
# Auto-generated from tests/ui/const-generics/associated-const-bindings/dyn-compat-symbol-mangling.rs#v0
cd "$(dirname "$0")"
"$RUSTC" -C symbol-mangling-version=v0 --cfg v0 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
