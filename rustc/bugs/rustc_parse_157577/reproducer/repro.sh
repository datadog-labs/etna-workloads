#!/bin/bash
# Auto-generated from tests/ui/parser/dyn-2015-identifier.rs#fail
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib --edition 2015 --cfg fail -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
