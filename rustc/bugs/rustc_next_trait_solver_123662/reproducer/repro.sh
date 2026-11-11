#!/bin/bash
# Auto-generated from tests/ui/async-await/async-closures/constrained-but-no-upvars-yet.rs#current
cd "$(dirname "$0")"
"$RUSTC" --edition 2021 --cfg current -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
