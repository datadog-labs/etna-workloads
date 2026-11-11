#!/bin/bash
# Auto-generated from tests/ui/use/use-path-segment-kw.rs#e2015
cd "$(dirname "$0")"
"$RUSTC" --edition 2015 --cfg e2015 -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
