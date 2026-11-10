#!/bin/bash
"$RUSTC" --edition 2018 --crate-type lib --emit metadata -o out.rmeta main.rs 2>&1 | grep -v "^warning"
echo "exit: $?"
