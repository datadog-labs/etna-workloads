#!/bin/bash
bash -c '"$RUSTC" --edition 2021 --emit metadata --crate-type bin main.rs -o out.rmeta >log.txt 2>&1' 2>/dev/null
echo "status=$?"
