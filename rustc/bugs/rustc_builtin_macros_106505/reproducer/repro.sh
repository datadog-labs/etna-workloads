#!/bin/bash
"$RUSTC" --crate-type proc-macro --crate-name pm pm.rs --edition 2021 2>&1; echo "pm status $?"
"$RUSTC" main.rs --edition 2021 --extern pm=libpm.so -o main 2>&1; echo "main status $?"
[ -x main ] && ./main
