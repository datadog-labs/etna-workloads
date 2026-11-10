#!/bin/bash
"$RUSTC" --edition=2021 -Cdebuginfo=2 --crate-type=lib main.rs -o out.rlib 2>&1 | grep -E "^error|can't type" | sed 's/DefId.*//'
echo "status: ${PIPESTATUS[0]}"
