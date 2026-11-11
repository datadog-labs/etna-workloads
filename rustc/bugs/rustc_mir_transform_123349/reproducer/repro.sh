#!/bin/bash
rm -f main
out=$("$RUSTC" --edition=2021 -O -A warnings main.rs -o main 2>&1); st=$?
echo "$out" | head -4 | cut -c1-200
echo "compile status: $st"
[ -x main ] && ./main
