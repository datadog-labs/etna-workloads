#!/bin/bash
# Auto-generated from tests/ui/dyn-compatibility/avoid-ice-on-warning-2.rs#new
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 --cfg new -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
