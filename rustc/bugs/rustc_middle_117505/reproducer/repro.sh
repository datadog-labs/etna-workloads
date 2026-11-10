#!/bin/bash
"$RUSTC" --edition 2021 --crate-type lib --error-format short main.rs 2>&1
"$RUSTC" --edition 2021 --crate-type lib --diagnostic-width 100 main.rs 2>&1 | grep -A3 'further restricting'
echo "status=$?"
