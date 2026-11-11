#!/bin/bash
# Auto-generated from tests/ui/inline-const/dont-eval-const-block-during-promotion.rs#fail
cd "$(dirname "$0")"
"$RUSTC" --cfg fail -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
