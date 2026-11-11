#!/bin/bash
# Auto-generated from tests/ui/parser/attribute/properly-recover-from-trailing-outer-attribute-in-body-2.rs
cd "$(dirname "$0")"
"$RUSTC"  -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
