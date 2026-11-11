#!/bin/bash
# Auto-generated from tests/ui/consts/different-fn-ptr-binders-during-ctfe.rs#stable
cd "$(dirname "$0")"
"$RUSTC" --cfg stable -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
