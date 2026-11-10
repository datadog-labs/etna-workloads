#!/bin/bash
"$RUSTC" --crate-type lib --crate-name aux aux.rs 2>&1
"$RUSTC" --crate-type lib --emit metadata -o out.rmeta --extern aux=libaux.rlib main.rs 2>&1 | grep -E 'help:|^error'
