#!/bin/bash
"$RUSTC" --edition 2021 -C debug-assertions=yes -C opt-level=0 -A warnings main.rs -o m 2>&1
echo "compile: $?"
(./m 2>err.txt; echo "run: $?") 2>/dev/null
grep -c "invalid value" err.txt
