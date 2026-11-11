#!/bin/bash
"$RUSTC" --crate-type lib --crate-name aux aux.rs --emit metadata,link -o libaux.rlib 2>&1
"$RUSTC" --edition 2021 --emit metadata --extern aux=libaux.rlib main.rs --out-dir out 2>&1 | grep -E "^(error|thread|.*does not have)" 
echo "status: ${PIPESTATUS[0]}"
