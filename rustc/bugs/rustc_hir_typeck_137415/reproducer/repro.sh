#!/bin/bash
"$RUSTC" --crate-type lib --crate-name q q.rs -o libq.rlib 2>&1
"$RUSTC" --edition 2021 main.rs --extern q=libq.rlib --emit metadata -o main.rmeta 2>&1
echo "status $?"
