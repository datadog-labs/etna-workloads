#!/bin/bash
"$RUSTC" --edition=2015 --crate-type=lib --crate-name=mac mac.rs 2>&1; echo "lib: $?"
"$RUSTC" --edition=2024 --crate-type=bin --extern mac=libmac.rlib main.rs -o main 2>&1; echo "bin: $?"
