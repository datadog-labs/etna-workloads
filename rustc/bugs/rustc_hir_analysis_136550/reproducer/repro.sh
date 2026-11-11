#!/bin/bash
# Auto-generated from tests/ui/impl-trait/in-trait/dump.rs
cd "$(dirname "$0")"
"$RUSTC" -Zverbose-internals -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
