#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib --emit metadata -o out.rmeta main.rs 2>&1
echo "status: $?"
