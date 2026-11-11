#!/bin/bash
"$RUSTC" --crate-type lib --emit metadata --error-format=human --color never main.rs 2>&1
echo "status: $?"
