#!/bin/bash
"$RUSTC" --crate-type lib --crate-name aux --edition 2021 aux.rs 2>&1; echo "aux status $?"
"$RUSTC" --crate-type lib --edition 2021 --emit metadata -L . --extern aux=libaux.rlib main.rs 2>&1; echo "status $?"
