#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib --emit metadata -A unused main.rs 2>&1
echo "status: $?"
