#!/bin/bash
"$RUSTC" --crate-type lib --crate-name aux --edition 2021 aux.rs --out-dir . 2>&1
"$RUSTC" --edition 2021 --extern aux=libaux.rlib -L . --emit metadata --out-dir . main.rs 2>&1
echo "status=$?"
