#!/bin/bash
"$RUSTC" --edition 2021 --emit metadata --crate-type lib --out-dir . --error-format json --json future-incompat -Zfuture-incompat-test -A unused main.rs 2>&1 | grep -o '`-A unused-variables` implied by `-A unused`' | head -1
echo "done"
