#!/bin/bash
# Auto-generated from tests/ui/debuginfo/dwarf-versions.rs#five
cd "$(dirname "$0")"
"$RUSTC" -Cdwarf-version=5 -g --target x86_64-unknown-linux-gnu --crate-type cdylib --cfg five --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
