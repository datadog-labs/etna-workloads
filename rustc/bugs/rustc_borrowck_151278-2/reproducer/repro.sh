#!/bin/bash
"$RUSTC" --emit=metadata --crate-type=lib --error-format=human --color=never main.rs 2>&1
echo "exit=$?"
