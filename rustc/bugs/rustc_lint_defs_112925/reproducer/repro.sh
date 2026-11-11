#!/bin/bash
# Auto-generated from tests/ui/consts/timeout.rs
cd "$(dirname "$0")"
"$RUSTC" --crate-type=lib -Ztiny-const-eval-limit -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
