#!/bin/bash
# Auto-generated from tests/ui/consts/required-consts/collect-in-dead-fn-behind-assoc-type.rs#noopt
cd "$(dirname "$0")"
"$RUSTC" -Copt-level=0 --cfg noopt -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
