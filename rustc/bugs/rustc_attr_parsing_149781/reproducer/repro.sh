#!/bin/bash
"$RUSTC" --edition 2024 --crate-type proc-macro --crate-name pm pm.rs 2>&1
"$RUSTC" --edition 2024 --extern pm=libpm.so main.rs -o main.out 2>&1
echo "exit: $?"
