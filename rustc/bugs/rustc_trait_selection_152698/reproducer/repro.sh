#!/bin/bash
"$RUSTC" --edition 2024 --crate-type lib -Zforce-unstable-if-unmarked --emit metadata --error-format short -o out.rmeta main.rs 2>&1
echo "status=$?"
"$RUSTC" --edition 2024 --crate-type lib -Zforce-unstable-if-unmarked --emit metadata -o out.rmeta main.rs 2>&1 | grep -n 'is not implemented'
