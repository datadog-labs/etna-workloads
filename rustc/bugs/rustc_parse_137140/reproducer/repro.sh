#!/bin/bash
# Auto-generated from tests/ui/parser/raw/raw-idents.rs#e2015
cd "$(dirname "$0")"
"$RUSTC" --edition 2015 --cfg e2015 --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
