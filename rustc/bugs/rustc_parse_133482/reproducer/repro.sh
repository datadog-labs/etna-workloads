#!/bin/bash
# Auto-generated from tests/ui/lifetimes/raw/immediately-followed-by-lt.rs#e2021
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 --cfg e2021 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
