#!/bin/bash
# Auto-generated from tests/ui/traits/copy-is-not-modulo-regions.rs#not_static
cd "$(dirname "$0")"
"$RUSTC" --cfg not_static -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
