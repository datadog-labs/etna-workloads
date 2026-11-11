#!/bin/bash
"$RUSTC" --edition 2024 --crate-type lib --emit metadata -o x.rmeta --color never main.rs 2>&1
echo "status $?"
