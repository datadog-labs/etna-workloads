#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib --emit metadata --error-format=human --color never main.rs 2>&1
echo "status $?"
