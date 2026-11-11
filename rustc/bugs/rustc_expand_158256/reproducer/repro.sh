#!/bin/bash
"$RUSTC" --crate-type proc-macro --edition 2021 pm.rs 2>&1; echo "pm: $?"
"$RUSTC" --edition 2021 --extern pm=libpm.so main.rs 2>&1; echo "main: $?"
