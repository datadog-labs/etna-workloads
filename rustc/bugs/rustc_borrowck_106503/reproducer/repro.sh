#!/bin/bash
# Auto-generated from tests/ui/impl-trait/issues/issue-105826.rs#current
cd "$(dirname "$0")"
"$RUSTC" --cfg current --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
