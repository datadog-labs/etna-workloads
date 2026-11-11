#!/bin/bash
"$RUSTC" --crate-type lib --crate-name aux aux.rs --emit metadata,link -o libaux.rlib 2>&1
"$RUSTC" --edition 2021 --extern aux=libaux.rlib main.rs --emit metadata -o out.rmeta 2>&1 | sed 's/-->.*main.rs/--> main.rs/'
echo "status ${PIPESTATUS[0]}"
