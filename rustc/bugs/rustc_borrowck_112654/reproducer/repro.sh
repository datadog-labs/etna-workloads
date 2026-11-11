#!/bin/bash
# Auto-generated from tests/ui/nll/issue-112604-closure-output-normalize.rs#current
cd "$(dirname "$0")"
"$RUSTC" --cfg current --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
