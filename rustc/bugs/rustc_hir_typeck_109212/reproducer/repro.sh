#!/bin/bash
"$RUSTC" --crate-type lib --crate-name aux --edition 2021 aux.rs --emit metadata,link -o libaux.rlib 2>&1
"$RUSTC" --edition 2021 --extern aux=libaux.rlib main.rs --emit metadata -o out.rmeta 2>&1
echo "exit: $?"
