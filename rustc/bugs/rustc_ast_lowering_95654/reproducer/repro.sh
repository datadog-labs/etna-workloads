#!/bin/bash
# Auto-generated from tests/ui/async-await/issues/issue-78654.rs#full
cd "$(dirname "$0")"
"$RUSTC" --edition 2018 --cfg full -o prog main.rs 2>&1; echo "rustc exit: $?"
rm -f prog out.rmeta
