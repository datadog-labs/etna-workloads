#!/bin/bash
"$RUSTC" --crate-type lib --crate-name aux --edition 2021 aux.rs --emit metadata,link -o libaux.rlib 2>&1
"$RUSTC" --edition 2021 --crate-type lib --emit metadata -o out.rmeta --extern aux=libaux.rlib main.rs 2>&1 | grep -E '^error|panicked' | sed 's/(.*//'
echo "status: ${PIPESTATUS[0]}"
