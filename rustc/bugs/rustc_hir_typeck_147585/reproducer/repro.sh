#!/bin/bash
"$RUSTC" --crate-type lib --edition 2021 aux.rs 2>&1
"$RUSTC" --edition 2021 --extern aux=libaux.rlib main.rs 2>&1
echo "exit=$?"
