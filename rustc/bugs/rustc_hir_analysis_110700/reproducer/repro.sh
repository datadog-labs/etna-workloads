#!/bin/bash
bash -c '"$RUSTC" --edition 2021 --emit metadata --crate-type lib -o out.rmeta main.rs > out.txt 2>&1; exit $?' 2>/dev/null
s=$?
cat out.txt
echo "status: $s"
