#!/bin/bash
"$RUSTC" --crate-type lib --crate-name aux --edition 2021 aux.rs 2>&1
echo "aux status $?"
"$RUSTC" --edition 2021 --extern aux=libaux.rlib main.rs -o main.out 2>&1
echo "main status $?"
