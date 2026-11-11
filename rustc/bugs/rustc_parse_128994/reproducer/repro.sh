#!/bin/bash
"$RUSTC" --crate-type proc-macro --crate-name pm --edition 2021 pm.rs 2>&1
echo "pm status $?"
"$RUSTC" --edition 2021 --emit metadata --extern pm=libpm.so main.rs 2>&1
echo "status $?"
