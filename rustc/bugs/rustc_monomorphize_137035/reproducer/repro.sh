#!/bin/bash
# Auto-generated from tests/ui/closures/eager-mono-with-normalizable-upvars.rs
cd "$(dirname "$0")"
"$RUSTC" -Clink-dead-code -Csymbol-mangling-version=v0 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
